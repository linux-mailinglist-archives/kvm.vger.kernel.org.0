Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B825F2B0C75
	for <lists+kvm@lfdr.de>; Thu, 12 Nov 2020 19:20:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726497AbgKLSUo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Nov 2020 13:20:44 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:52311 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726394AbgKLSUo (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 12 Nov 2020 13:20:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605205243;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4GHjztsMnOKVEcPjdBrH3zyHtPVJGNb0Blp72NicGCM=;
        b=hR9HHLrhtLwDTtI2apdNx90XYKHZpCvFtUCaUnDECMNqGojAlhyiNzgfvA7tU9riEeRFPp
        08H0SuM6MRXBjl6z+Lg5+HC/INEU/paa+QuyPKFXqK+4LBlcA+l2u9faBBU1PwGnvqK7/M
        o7JaF7dma1LTByRikdgDT+LfoZjgdUU=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-215-HKZPm5o4N--OPZKEABHBaw-1; Thu, 12 Nov 2020 13:20:41 -0500
X-MC-Unique: HKZPm5o4N--OPZKEABHBaw-1
Received: by mail-qt1-f199.google.com with SMTP id o16so4055992qtr.14
        for <kvm@vger.kernel.org>; Thu, 12 Nov 2020 10:20:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4GHjztsMnOKVEcPjdBrH3zyHtPVJGNb0Blp72NicGCM=;
        b=Lupa2VWlAJWsbRtILjCUndnUKwe2444dDoXQMBbDXGzoQQVPHe+3gm/ZxldzaDLAL7
         G5Mtoiacr3FUxYZElJuGAhhfYcUvQBw0q8e/0vvgGF2bmfIHz702vtk1wB5SyFCfXBGw
         EMCFdE/IN0jEFxLN9sjn9V0kimMa1DGsKF9053rMG6s3hgE8tdmKL0sm+j9fOQHfhaCA
         YpntNzYYQjsc2hcyporCO+tijYCQFz+B+ZHb85ASPqz4RRg4ye80YKGnJpMvLa692+rF
         6u9fMJ0pFf/yo2MUZc4otGnWiuMyebFGtjycFR/0HDvDAy7SSBrIFWpm/vTS4lVxOhOj
         Mf4A==
X-Gm-Message-State: AOAM533CpcQgzYAEiDwXMl9e/1kFiPpfqTnCq5aPYL6Ol0DA3FVhnoEA
        wQdpHh4tLRzXFEvl5cqG/b9k4bULTRUtuFJcukpqCX0ydUUSDl2TDCosp65ff5sJMJ63swmdDt1
        nNFiLNHM8T/Lx
X-Received: by 2002:ac8:13c2:: with SMTP id i2mr451224qtj.338.1605205241402;
        Thu, 12 Nov 2020 10:20:41 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwgEa9xIVIuHMfFiRBGLwivOSk84qL6yuOaWOy+QnP2TpgwLTDuSPEJv6v4g8tsrNldvXRKsw==
X-Received: by 2002:ac8:13c2:: with SMTP id i2mr451195qtj.338.1605205241144;
        Thu, 12 Nov 2020 10:20:41 -0800 (PST)
Received: from xz-x1 (bras-vprn-toroon474qw-lp130-20-174-93-89-196.dsl.bell.ca. [174.93.89.196])
        by smtp.gmail.com with ESMTPSA id k70sm5560806qke.46.2020.11.12.10.20.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2020 10:20:34 -0800 (PST)
Date:   Thu, 12 Nov 2020 13:20:32 -0500
From:   Peter Xu <peterx@redhat.com>
To:     Andrew Jones <drjones@redhat.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, borntraeger@de.ibm.com,
        frankja@linux.ibm.com, bgardon@google.com
Subject: Re: [PATCH v2 06/11] KVM: selftests: dirty_log_test: Remove create_vm
Message-ID: <20201112182032.GU26342@xz-x1>
References: <20201111122636.73346-1-drjones@redhat.com>
 <20201111122636.73346-7-drjones@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201111122636.73346-7-drjones@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 11, 2020 at 01:26:31PM +0100, Andrew Jones wrote:
> +#define DIRTY_MEM_BITS			30 /* 1G */
> +#define DIRTY_MEM_SIZE			(1UL << 30)

Nit: could do s/30/DIRTY_MEM_BITS/

Reviewed-by: Peter Xu <peterx@redhat.com>

-- 
Peter Xu

