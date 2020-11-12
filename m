Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8A882B0C70
	for <lists+kvm@lfdr.de>; Thu, 12 Nov 2020 19:19:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726491AbgKLSTk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Nov 2020 13:19:40 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:31070 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726375AbgKLSTj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 12 Nov 2020 13:19:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605205179;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=aK3TatwJcbfzTSLZx3f8cWsTSWJfkmY/7jWTs64oFoA=;
        b=JRqyljbFiMNiE1FtwGlmomc5ozgmkieR77d8nYeLoDBR85Yj1p2qb58kVaA3adXzEYS0Vs
        8GPo5nuzVEswa0nTM/RQkdAn27YnXhr3r8PkdPHWvJST9m6ruWoJfjEr8iYJH/XGPnkmnx
        N6Goa5lzhOLzQgjIxpNR5+oYTo+dpJk=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-412-q5woCtpAP4OfFiowMHxeVg-1; Thu, 12 Nov 2020 13:19:37 -0500
X-MC-Unique: q5woCtpAP4OfFiowMHxeVg-1
Received: by mail-qv1-f69.google.com with SMTP id s3so4364542qve.13
        for <kvm@vger.kernel.org>; Thu, 12 Nov 2020 10:19:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=aK3TatwJcbfzTSLZx3f8cWsTSWJfkmY/7jWTs64oFoA=;
        b=Twuq3lVM99VrNKdOIoijsJc0j2U8gZPCRp3tJRdsQLMXClFZ1Nm0i9EMISKZyFuJkz
         F7ciUPlUt0bPKdoUIx6BgPr7w2VvtelPBCtCBCEf0emweVbGpAVm1yroDkljdFZVXD0L
         MHbEk4aLkx+DedVD9wCUnU1Vu+suQ9ga+ME4umQb5IOyCjvASFHhHdkQJIwPGemVCupU
         lXm382Gf1bMZSmCISoj/eFMcuHsyHHS5AqS5OJWfBLpBiZWhTv4ZRrQELBclvXb5G3GM
         5OLZ/2GN9rmMgUcauGVDC2kB7lomf+08agaqtvQBxDsj3VtLgoLLqXb5AmC4toO7Mi3p
         zJ9w==
X-Gm-Message-State: AOAM530b5vpA8GD/2/3NxWT20zV676Klbvz0P0EnZqeyVT+sIZOFlgfX
        tJdTTHKdgYf+oFlJ1kmfst157IB+W42OJLtDeewM+CqAUt8URx5+3VfpZSfCzbrDTJ24NlCioWc
        +Qi4UUesk1XWf
X-Received: by 2002:ad4:5387:: with SMTP id i7mr868907qvv.43.1605205176361;
        Thu, 12 Nov 2020 10:19:36 -0800 (PST)
X-Google-Smtp-Source: ABdhPJy8YR3LAW9SGXwVqyOMDOWeCLgLg0ls6KCezQO+3wvtiO+f4PcsvCv/Rg1NBNOVpwdIWNT+zw==
X-Received: by 2002:ad4:5387:: with SMTP id i7mr868890qvv.43.1605205176104;
        Thu, 12 Nov 2020 10:19:36 -0800 (PST)
Received: from xz-x1 (bras-vprn-toroon474qw-lp130-20-174-93-89-196.dsl.bell.ca. [174.93.89.196])
        by smtp.gmail.com with ESMTPSA id y187sm5299940qka.116.2020.11.12.10.19.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2020 10:19:35 -0800 (PST)
Date:   Thu, 12 Nov 2020 13:19:34 -0500
From:   Peter Xu <peterx@redhat.com>
To:     Andrew Jones <drjones@redhat.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, borntraeger@de.ibm.com,
        frankja@linux.ibm.com, bgardon@google.com
Subject: Re: [PATCH v2 03/11] KVM: selftests: Factor out guest mode code
Message-ID: <20201112181934.GT26342@xz-x1>
References: <20201111122636.73346-1-drjones@redhat.com>
 <20201111122636.73346-4-drjones@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201111122636.73346-4-drjones@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 11, 2020 at 01:26:28PM +0100, Andrew Jones wrote:
> demand_paging_test, dirty_log_test, and dirty_log_perf_test have
> redundant guest mode code. Factor it out.
> 
> Also, while adding a new include, remove the ones we don't need.
> 
> Signed-off-by: Andrew Jones <drjones@redhat.com>

Reviewed-by: Peter Xu <peterx@redhat.com>

-- 
Peter Xu

