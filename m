Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BEE5915A919
	for <lists+kvm@lfdr.de>; Wed, 12 Feb 2020 13:25:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727946AbgBLMZa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Feb 2020 07:25:30 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:37447 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727906AbgBLMZ3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 12 Feb 2020 07:25:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581510328;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pDUH9gbb0ZVsTJG5o97WNAaGdKzWJn2GoPx52Q8GeLg=;
        b=HqCZkzW/vbmISwHykXQzcNsR+Eik7s2nlee0WkvVaYSShyGRMcdo8DazQw2WoCmSK7i8PJ
        fJhaIlDog+x8E+e4TlbTMmY4bnjXWAwhYoagbZAu4DENWwcfUMCPQPWrUsbU0NZ+NAOBqL
        M1HS46lTS0p6KYHBVys6PQn9sPGbWKY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-79-4MsLLPGdNHGjriyOEYqYgA-1; Wed, 12 Feb 2020 07:25:27 -0500
X-MC-Unique: 4MsLLPGdNHGjriyOEYqYgA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 11404101FC67;
        Wed, 12 Feb 2020 12:25:26 +0000 (UTC)
Received: from [10.36.116.37] (ovpn-116-37.ams2.redhat.com [10.36.116.37])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 52F1E5D9E2;
        Wed, 12 Feb 2020 12:25:21 +0000 (UTC)
Subject: Re: [PATCH v5 0/4] selftests: KVM: AMD Nested SVM test infrastructure
To:     Paolo Bonzini <pbonzini@redhat.com>, eric.auger.pro@gmail.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        vkuznets@redhat.com
Cc:     thuth@redhat.com, drjones@redhat.com, wei.huang2@amd.com,
        krish.sadhukhan@oracle.com
References: <20200207142715.6166-1-eric.auger@redhat.com>
 <25441007-2b1a-f98a-3ca8-ffe9849d7031@redhat.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <7fdf6081-44a1-35e6-a652-69c753a17491@redhat.com>
Date:   Wed, 12 Feb 2020 13:25:18 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <25441007-2b1a-f98a-3ca8-ffe9849d7031@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Paolo,

On 2/12/20 1:09 PM, Paolo Bonzini wrote:
> On 07/02/20 15:27, Eric Auger wrote:
>>
>> History:
>> v4 -> v5:
>> - Added "selftests: KVM: Remove unused x86_register enum"
>> - reorder GPRs within gpr64_regs
>> - removed vmcb_hva and save_area_hva from svm_test_data
>> - remove the naming for vmcb_gpa in run_guest
> 
> I preferred v4. :)

Ah OK

I queued the patch to remove the unused enum though.

Thanks

Eric
> 
> Paolo
> 

