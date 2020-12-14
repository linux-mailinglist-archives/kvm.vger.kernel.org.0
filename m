Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C54832D9804
	for <lists+kvm@lfdr.de>; Mon, 14 Dec 2020 13:33:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731433AbgLNMab (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Dec 2020 07:30:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407783AbgLNMaV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Dec 2020 07:30:21 -0500
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2B3FC0613CF;
        Mon, 14 Dec 2020 04:29:40 -0800 (PST)
Received: by mail-wm1-x343.google.com with SMTP id q75so15038497wme.2;
        Mon, 14 Dec 2020 04:29:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=vBsPBj7XChs5jMSzaw4CDdV6qviOpQdMX+GGrGqpZSg=;
        b=rh6U9xNW1uMYHWJF5UiHIyJgznNtRGWnxTy4VTIiZz+3g1rjxHy6U/pGvJo35wpQns
         JeAIujuyCU2IvtOdlRIqNHc+VHoi0/kww6NhBpV3yKY5xzduBJ9U7oM3STFKUNTJMv/S
         grhShVzSTGRenfjnRZdaaAaBqJe79OoQ+beq1F+PAX0QybGCX6YtOFFmGft5AckQH8OX
         3zZ4pAstfD1YkcXPcUQ5HgiZ3T4v9ab5N2wUNMkigsWaurRzpUCAP+FKbRgYDIl0DCVA
         +9T2Ylfmc2wHOaZxETRDIp0WjpO5KS7q6ckid4sMqC9PMoOxchgyTwdlK8Y0JBr2eSQW
         zWfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:to:cc:references:from:subject:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vBsPBj7XChs5jMSzaw4CDdV6qviOpQdMX+GGrGqpZSg=;
        b=KNubvL3/zGolKivULB2Zt5jLacStLTOF8G1y0oKb7Xmro70IhfvBeHGsPuAFc40aNl
         i1HobJwo8XbGYMPmyfjtVBiCi+DeJbOJNaIJ3mLWI5jA+4t4qcsgLIRKyki9d/YSfst/
         qEQMRDcXeotQVEoLtAkq9hz5aSwxYQTBxvMgMoc/a0EUzmTM9KXhPyrC09UFTtSOG2H8
         T3hWmk0KovtyRjOs4TvDlHfDKHFFql4xh+0F7f2yg8OtY9Agw9wzUuRgGLj2WFoRiCZ8
         LBCJnYONLwRx1LkZZcrAa4v0tknZTbe90LcpGdetHuvSqjtehLcqBb5l35FmT1VjEHYD
         yVTQ==
X-Gm-Message-State: AOAM532ZjJGmSTixGZslLxyQ82ZssNrcZDaGEpUNZLDq647gW0MQixE2
        p3+ZacxQgPpvQd8yE0svaLI=
X-Google-Smtp-Source: ABdhPJwevGJaa5n7bLmMFg4hJP6T213os41e/1qetovZlAQlxveMZialFBqcmxIBOldhKnfBsr5o6Q==
X-Received: by 2002:a1c:bd43:: with SMTP id n64mr27702089wmf.169.1607948976057;
        Mon, 14 Dec 2020 04:29:36 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id d15sm31048563wrx.93.2020.12.14.04.29.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Dec 2020 04:29:35 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
To:     Tom Lendacky <thomas.lendacky@amd.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org
Cc:     Jim Mattson <jmattson@google.com>, Joerg Roedel <joro@8bytes.org>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Brijesh Singh <brijesh.singh@amd.com>
References: <cover.1607620209.git.thomas.lendacky@amd.com>
 <618380488358b56af558f2682203786f09a49483.1607620209.git.thomas.lendacky@amd.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v5 02/34] KVM: SVM: Remove the call to
 sev_platform_status() during setup
Message-ID: <a1a912c7-b2f8-561b-c569-d74ff946c9f5@redhat.com>
Date:   Mon, 14 Dec 2020 13:29:32 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <618380488358b56af558f2682203786f09a49483.1607620209.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/12/20 18:09, Tom Lendacky wrote:
> From: Tom Lendacky <thomas.lendacky@amd.com>
> 
> When both KVM support and the CCP driver are built into the kernel instead
> of as modules, KVM initialization can happen before CCP initialization. As
> a result, sev_platform_status() will return a failure when it is called
> from sev_hardware_setup(), when this isn't really an error condition.
> 
> Since sev_platform_status() doesn't need to be called at this time anyway,
> remove the invocation from sev_hardware_setup().
> 
> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
> ---
>   arch/x86/kvm/svm/sev.c | 22 +---------------------
>   1 file changed, 1 insertion(+), 21 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index c0b14106258a..a4ba5476bf42 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -1127,9 +1127,6 @@ void sev_vm_destroy(struct kvm *kvm)
>   
>   int __init sev_hardware_setup(void)
>   {
> -	struct sev_user_data_status *status;
> -	int rc;
> -
>   	/* Maximum number of encrypted guests supported simultaneously */
>   	max_sev_asid = cpuid_ecx(0x8000001F);
>   
> @@ -1148,26 +1145,9 @@ int __init sev_hardware_setup(void)
>   	if (!sev_reclaim_asid_bitmap)
>   		return 1;
>   
> -	status = kmalloc(sizeof(*status), GFP_KERNEL);
> -	if (!status)
> -		return 1;
> -
> -	/*
> -	 * Check SEV platform status.
> -	 *
> -	 * PLATFORM_STATUS can be called in any state, if we failed to query
> -	 * the PLATFORM status then either PSP firmware does not support SEV
> -	 * feature or SEV firmware is dead.
> -	 */
> -	rc = sev_platform_status(status, NULL);
> -	if (rc)
> -		goto err;
> -
>   	pr_info("SEV supported\n");
>   
> -err:
> -	kfree(status);
> -	return rc;
> +	return 0;
>   }
>   
>   void sev_hardware_teardown(void)
> 

Queued with Cc: stable.

Note that sev_platform_status now can become static within 
drivers/crypto/ccp/sev-dev.c.

Paolo
