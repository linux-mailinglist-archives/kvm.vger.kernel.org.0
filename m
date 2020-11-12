Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03A3E2B0C61
	for <lists+kvm@lfdr.de>; Thu, 12 Nov 2020 19:12:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726488AbgKLSMI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Nov 2020 13:12:08 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:57089 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726156AbgKLSMI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 12 Nov 2020 13:12:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605204727;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=pJ5wQYLC3GChkVjfWGK6A8bFApo9YWswEdMWlgI5cI0=;
        b=FyqY6Ph7u36vgI8YTGoNe6DmI08vcmyK+j5tLZh/Fn24xGDI7Dt3PaIgPk/H2Jdveale48
        G3RqSuQe+D2MpXNP8RcIIOt4tIUk6++pco62tjOPMRbrrnu9ZrBrvvbuSg7TCjpj8iguH7
        5AHe7iRSvfYKtD/wnPWDOxrpttTNEek=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-559-XJHVzRgONAGtib6GvrPDrA-1; Thu, 12 Nov 2020 13:12:05 -0500
X-MC-Unique: XJHVzRgONAGtib6GvrPDrA-1
Received: by mail-qk1-f199.google.com with SMTP id x2so4809628qkd.23
        for <kvm@vger.kernel.org>; Thu, 12 Nov 2020 10:12:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=pJ5wQYLC3GChkVjfWGK6A8bFApo9YWswEdMWlgI5cI0=;
        b=RErU3a4txAuyPaLY0ZHpbZsd7dOrWZKQv1aVL2BXy+6EX9gqVtud2W23xo47y1CUwu
         Vp2p4y9zNCFpbPM2Aj5DkFobrUzJ1VWWDp7nq3kgx8ASiGuCJcWSmgp7QOJwhav/gMP2
         wMiC6I9vu2vPHIjVviYiGw5AcCv6uwfj1/MPzId3jsx4g7egK4VRvdVRTiJz2Nkl89am
         qArmeDLQiR1XcuyvejTgWX+x1kE5TboOx6HdHzgnYoJwLLWFpymOpARmiZvFMRez1FTf
         pXNwfh+VJObLrAp3YAJF0HCUK1bDATAO27qQjUFYQOoKy+s0xpr2VixDiCNoAkyfIkFx
         2BnQ==
X-Gm-Message-State: AOAM533L4afsejVem7rq1olcHFLDWJcaXU0jHI+VHxB0k752eIdL1PDv
        Gu/lZKmgQyOBrHiCZlmn287UCpo5fNO5JUUDk/Iyai5jYYYPnsK+anUzonL8UetLOYM83c991K3
        1iBGm6WZEjUdj
X-Received: by 2002:aed:3048:: with SMTP id 66mr408898qte.374.1605204724061;
        Thu, 12 Nov 2020 10:12:04 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxxgl+twEy/sZEwLQksUQNivslyWV3jIha26qpmR2c+zQrF+FpNmTEXirbvoEl07kD1+Ia/TA==
X-Received: by 2002:aed:3048:: with SMTP id 66mr408884qte.374.1605204723853;
        Thu, 12 Nov 2020 10:12:03 -0800 (PST)
Received: from xz-x1 (bras-vprn-toroon474qw-lp130-20-174-93-89-196.dsl.bell.ca. [174.93.89.196])
        by smtp.gmail.com with ESMTPSA id p1sm5330747qkc.100.2020.11.12.10.12.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2020 10:12:03 -0800 (PST)
Date:   Thu, 12 Nov 2020 13:12:01 -0500
From:   Peter Xu <peterx@redhat.com>
To:     Andrew Jones <drjones@redhat.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, borntraeger@de.ibm.com,
        frankja@linux.ibm.com, bgardon@google.com
Subject: Re: [PATCH v2 01/11] KVM: selftests: Update .gitignore
Message-ID: <20201112181201.GR26342@xz-x1>
References: <20201111122636.73346-1-drjones@redhat.com>
 <20201111122636.73346-2-drjones@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201111122636.73346-2-drjones@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 11, 2020 at 01:26:26PM +0100, Andrew Jones wrote:
> Add x86_64/tsc_msrs_test and remove clear_dirty_log_test.
> 
> Reviewed-by: Ben Gardon <bgardon@google.com>
> Signed-off-by: Andrew Jones <drjones@redhat.com>
> ---
>  tools/testing/selftests/kvm/.gitignore | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
> index 7a2c242b7152..ceff9f4c1781 100644
> --- a/tools/testing/selftests/kvm/.gitignore
> +++ b/tools/testing/selftests/kvm/.gitignore
> @@ -18,13 +18,13 @@
>  /x86_64/vmx_preemption_timer_test
>  /x86_64/svm_vmcall_test
>  /x86_64/sync_regs_test
> +/x86_64/tsc_msrs_test
>  /x86_64/vmx_apic_access_test
>  /x86_64/vmx_close_while_nested_test
>  /x86_64/vmx_dirty_log_test
>  /x86_64/vmx_set_nested_state_test
>  /x86_64/vmx_tsc_adjust_test
>  /x86_64/xss_msr_test
> -/clear_dirty_log_test
>  /demand_paging_test
>  /dirty_log_test
>  /dirty_log_perf_test

This seems to conflict with another patch that are already on kvm/queue, so
this series may need a rebase (and, seems this is not the only conflict)...

-- 
Peter Xu

