Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A1326CACBD
	for <lists+kvm@lfdr.de>; Mon, 27 Mar 2023 20:09:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230107AbjC0SJH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Mar 2023 14:09:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229525AbjC0SJG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Mar 2023 14:09:06 -0400
Received: from mailtransmit05.runbox.com (mailtransmit05.runbox.com [IPv6:2a0c:5a00:149::26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F28E30D2
        for <kvm@vger.kernel.org>; Mon, 27 Mar 2023 11:08:53 -0700 (PDT)
Received: from mailtransmit03.runbox ([10.9.9.163] helo=aibo.runbox.com)
        by mailtransmit05.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <mhal@rbox.co>)
        id 1pgrH1-00G4eR-8c
        for kvm@vger.kernel.org; Mon, 27 Mar 2023 20:08:51 +0200
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=rbox.co;
        s=selector2; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
        References:Cc:To:Subject:MIME-Version:Date:Message-ID;
        bh=ouv10Xx9gAlBjS51fEih3GeaFyXVAROhTsf4cSWthRY=; b=dcTcroKvGn897z9b0IkEkd/jdg
        QDjhSHoRcg/NC95niy9OqpCGOH8TbZFJjoZ8HbiHojXNAMzo7d/TejVaqVj1/EdKBCOYXpiDzZIl9
        5sKqc26EkJTDOhXBPFLiCa7RSW01vGYQAikEQuFN7bhlwtCS5W91HeWB+ukMsN2z0aCuUH/3Nn6PI
        NcFHlqRtkX3lYNi/Wku+7tHvRj8zwJIifB1v+IZB/N8PDNisKppCWka8H3OEU5b866Xjo0LjXvWub
        j53KmH9jZ0M2bSHmnt1D6hn+pTgSWs8hE5o4D2nfhAcrGzTtOJI/uQNeZbu4gDCJEhsavY0FbgizH
        P41wkFFg==;
Received: from [10.9.9.73] (helo=submission02.runbox)
        by mailtransmit03.runbox with esmtp (Exim 4.86_2)
        (envelope-from <mhal@rbox.co>)
        id 1pgrH0-00026n-Mb; Mon, 27 Mar 2023 20:08:50 +0200
Received: by submission02.runbox with esmtpsa  [Authenticated ID (604044)]  (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90_1)
        id 1pgrGu-0008UX-Ud; Mon, 27 Mar 2023 20:08:45 +0200
Message-ID: <da0dd5e9-9a86-b981-e783-3fd9b15150d3@rbox.co>
Date:   Mon, 27 Mar 2023 20:08:43 +0200
MIME-Version: 1.0
User-Agent: Thunderbird
Subject: Re: [PATCH 0/3] KVM: x86/emulator: Segment load fixes
Content-Language: pl-PL, en-GB
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com
References: <20230126013405.2967156-1-mhal@rbox.co>
 <Y9K5gahXK4kWdton@google.com>
From:   Michal Luczaj <mhal@rbox.co>
In-Reply-To: <Y9K5gahXK4kWdton@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.9 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/26/23 18:33, Sean Christopherson wrote:
> On Thu, Jan 26, 2023, Michal Luczaj wrote:
>> Two small fixes for __load_segment_descriptor(), along with a KUT
>> x86/emulator test.
>>
>> And a question to maintainers: is it ok to send patches for two repos in
>> one series?
> 
> No, in the future please send two separate series (no need to do so for this case).
> Us humans can easily figure out what's going on, but b4[*] gets confused, e.g.
> `b4 am` will fail.
> 
> What I usually do to connect the KVM-unit-test change to the kernel/KVM change is
> to post the kernel patches first, and then update the KVM-unit-test patch(es) to
> provide the lore link to the kernel patches.
> 
> Thanks for asking, and a _huge_ thanks for writing tests!
> ...

My pleasure ;) I've noticed two months have passed, but the test was not
merged. Is there something I should improve?

thanks,
Michal

