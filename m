Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 807501DB939
	for <lists+kvm@lfdr.de>; Wed, 20 May 2020 18:23:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726619AbgETQXc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 May 2020 12:23:32 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:21028 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726510AbgETQXc (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 20 May 2020 12:23:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589991810;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=NoVochZcFS3v4/Dvw5anGBO9w8j/2/n96KgXu49AdWA=;
        b=fBA1I2vDSI++blRuLzWQ6n1KmOJxsuvpokd4J1OHsAwcZIOlMAQDwmdltJTBFnx+4ywKiC
        WImAdbkZF1DAW6W1vMCmKVuG43r9pQdOuvrXUFAFUomtdIVR0n3gs8i98J9f9PHofZUieJ
        xSW6vcyL5mJGW6qjZq+agNOy2MOhGtg=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-352-Byu0JBhhM8meEF-LFgkcjg-1; Wed, 20 May 2020 12:23:29 -0400
X-MC-Unique: Byu0JBhhM8meEF-LFgkcjg-1
Received: by mail-ej1-f71.google.com with SMTP id x21so1554219ejb.14
        for <kvm@vger.kernel.org>; Wed, 20 May 2020 09:23:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=NoVochZcFS3v4/Dvw5anGBO9w8j/2/n96KgXu49AdWA=;
        b=EVYpPXNn28gHOD6nDvajoiWbCwWjxVS8xBEGHpLh0d7JSlLRQ41+VOZY3iWm4lGBNB
         SqWw1IWlMH7rKi4V4Fy10wjajKHinFAby7oVRGZQFBUxQmzZUcfUDc6xJ2ci27G9H0/K
         RXzARCYCxL5O2XZazgr3+xV/r0+rrv+zDzY4+OhjbEjctGdMGPDgPziS9g5YAGWmWoBL
         OY5slgBHfNeu4H+79coeJCZbUxvam57Q1WCDtwGnSqLg+1YuvcgrUNGx38hQ7vq8Rlup
         GJU8XuSlfACv3ZNHqUX2GUE3t+pW8Cvj3iAXm7KX1vSmuUr35PUmgB9ooJ+NYjWflocI
         5zYQ==
X-Gm-Message-State: AOAM533SZNu4PRWehtTw1i7+Iyne5/E64+5Vi07B6laOWoF1iZunMCue
        rJIMNhcGvL7wV59XSsyLSvhwPlm09k3YCOQqDBv3J6e55rcX06JTfg9IISeV58rtd0BmvjLgeCP
        mBP3CX5zJURnW
X-Received: by 2002:a17:906:415b:: with SMTP id l27mr4584381ejk.240.1589991807364;
        Wed, 20 May 2020 09:23:27 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy6D8uFHurXAxp3TFzy/tn3+V3RRSaJtWT2otMOBsMiXStjME+hqZObXrQKm8bEIzEbD/QnGQ==
X-Received: by 2002:a17:906:415b:: with SMTP id l27mr4584369ejk.240.1589991807185;
        Wed, 20 May 2020 09:23:27 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id s1sm2369800ejh.81.2020.05.20.09.23.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 May 2020 09:23:26 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>
Subject: Re: [PATCH 1/2] kvm: cosmetic: remove wrong braces in kvm_init_msr_list switch
In-Reply-To: <20200520160740.6144-2-mlevitsk@redhat.com>
References: <20200520160740.6144-1-mlevitsk@redhat.com> <20200520160740.6144-2-mlevitsk@redhat.com>
Date:   Wed, 20 May 2020 18:23:25 +0200
Message-ID: <877dx6tw1u.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Maxim Levitsky <mlevitsk@redhat.com> writes:

> I think these were added accidentally.
>
> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> ---
>  arch/x86/kvm/x86.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 471fccf7f8501..fe3a24fd6b263 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -5299,7 +5299,7 @@ static void kvm_init_msr_list(void)
>  				 !intel_pt_validate_hw_cap(PT_CAP_single_range_output)))
>  				continue;
>  			break;
> -		case MSR_IA32_RTIT_ADDR0_A ... MSR_IA32_RTIT_ADDR3_B: {
> +		case MSR_IA32_RTIT_ADDR0_A ... MSR_IA32_RTIT_ADDR3_B:
>  			if (!kvm_cpu_cap_has(X86_FEATURE_INTEL_PT) ||
>  				msrs_to_save_all[i] - MSR_IA32_RTIT_ADDR0_A >=
>  				intel_pt_validate_hw_cap(PT_CAP_num_address_ranges) * 2)
> @@ -5314,7 +5314,6 @@ static void kvm_init_msr_list(void)
>  			if (msrs_to_save_all[i] - MSR_ARCH_PERFMON_EVENTSEL0 >=
>  			    min(INTEL_PMC_MAX_GENERIC, x86_pmu.num_counters_gp))
>  				continue;
> -		}
>  		default:
>  			break;
>  		}

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

