Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED26273E8D9
	for <lists+kvm@lfdr.de>; Mon, 26 Jun 2023 20:30:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232030AbjFZSab (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Jun 2023 14:30:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232390AbjFZSaR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Jun 2023 14:30:17 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCF50CC
        for <kvm@vger.kernel.org>; Mon, 26 Jun 2023 11:30:15 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id d2e1a72fcca58-668704a5b5bso3378555b3a.0
        for <kvm@vger.kernel.org>; Mon, 26 Jun 2023 11:30:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687804215; x=1690396215;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QremIcf7iRsG9qDbVkiKuaPlPn4048SsLFTCD0Ysv2M=;
        b=GrCr0ShrComG94KO0A48krXyErRVG0IStcDfGl5TX8RiCg0R2CSQR1nisSrup1rf6z
         6dqupniRxWyPxn8qp0LRoPcI+WPmSmH96VeeN3UyBZdci+WpqRl607qepvkTnEGw9mk0
         DF5XiULqsAQWv5T3L4Ms8mRg6yjWnKsi+cWNkMe0ZkKoZVYsVN1FGgTWRiNErDoG1aNg
         b6O59sTfTNjxN9LVzftbLgo6ol5bTvj3XTjkO0ODfEIpUOZ+vecrLKXhY8kdmFjFVPdM
         6k00xP2W9nnPXc8iAEPpSlX/ycUeivi6ZvrnrDoP4TZHj/Rzj/kvlxU2EFDznAWtWACn
         Zz5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687804215; x=1690396215;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QremIcf7iRsG9qDbVkiKuaPlPn4048SsLFTCD0Ysv2M=;
        b=i+Q5BXuZj/P59d1mgEEoa4d8kiexLk9AMdkY2aNZ2kSKly4pB9jr79JPSuoVNtQ8h9
         IyJyqTaeISRFGx0UHmIH6raUJ5NKxx65sn9bRVEvuwNZser8pZtPmcKB6Pw/qEbcS5Ov
         B+tM6Knb/NtiYyTOZT0KRCoSYdOciyHJ6snz5cXzhvjwPnc6RNwyNKnSesbIpIy5akBu
         3aDDAFPAcO+6T3aGZ/EfCskWKGM6YxucwHD6pqugTRb/v0KRi9ly1NO2uGZVY98Zifmf
         v8BWCOlzGidu4vUkWhYFaBpO/9b8DVoTCtMM4Mm90r3mnj6VW8KzkqC7ouLk0kPFiRGJ
         5o7g==
X-Gm-Message-State: AC+VfDyy1etSywa3EEmR6nLif3dqyXYVXHOwRSe2gbBEOL5KSdmsmV/2
        hFbbDLKrBTi43pizbZLoA4c=
X-Google-Smtp-Source: ACHHUZ78LEkj8TNJrxfdIeuliRkkaDbVmg5Nv3baBTKc2IIiRiWXBDFe94AKZl3+69U9V87EyHAHEQ==
X-Received: by 2002:a05:6a20:3d89:b0:125:7c45:ad6 with SMTP id s9-20020a056a203d8900b001257c450ad6mr14877832pzi.15.1687804215111;
        Mon, 26 Jun 2023 11:30:15 -0700 (PDT)
Received: from smtpclient.apple ([66.170.99.1])
        by smtp.gmail.com with ESMTPSA id h3-20020a62b403000000b006468222af91sm4103121pfn.48.2023.06.26.11.30.13
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 26 Jun 2023 11:30:14 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.600.7\))
Subject: Re: [kvm-unit-tests PATCH v2 1/6] efi: keep efi debug information in
 a separate file
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <20230626-74deb6543bf4c51ef9b723f2@orel>
Date:   Mon, 26 Jun 2023 11:30:03 -0700
Cc:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        Nikos Nikoleris <nikos.nikoleris@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Content-Transfer-Encoding: 7bit
Message-Id: <827839D1-F5F3-40FA-A57F-FC5DB22E2568@gmail.com>
References: <20230625230716.2922-1-namit@vmware.com>
 <20230625230716.2922-2-namit@vmware.com>
 <20230626-74deb6543bf4c51ef9b723f2@orel>
To:     Andrew Jones <andrew.jones@linux.dev>
X-Mailer: Apple Mail (2.3731.600.7)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On Jun 25, 2023, at 11:18 PM, Andrew Jones <andrew.jones@linux.dev> wrote:
> 
> !! External Email
> 
> On Sun, Jun 25, 2023 at 11:07:11PM +0000, Nadav Amit wrote:
>> From: Nadav Amit <namit@vmware.com>
>> 
>> Debugging tests that run on EFI is hard because the debug information is
>> not included in the EFI file. Dump it into a separeate .debug file to
>> allow the use of gdb or pretty_print_stacks script.
>> 
>> Signed-off-by: Nadav Amit <namit@vmware.com>
>> 
>> ---
>> 
>> v1->v2:
>> * Making clean should remove .debug [Andrew]
> 
> I forgot to point out in the previous review that not only do we need
> to clean but also add *.debug to .gitignore

I will do that for v3.

I did not (and still do not) understand what change you want for run_tests.sh
so I would indeed appreciate if you do this one.

