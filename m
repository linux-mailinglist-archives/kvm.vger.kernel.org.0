Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BFE152FA1D
	for <lists+kvm@lfdr.de>; Sat, 21 May 2022 10:51:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241299AbiEUIvb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 21 May 2022 04:51:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239634AbiEUIv3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 21 May 2022 04:51:29 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A97F120BDE
        for <kvm@vger.kernel.org>; Sat, 21 May 2022 01:51:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653123085;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type;
        bh=yx5IpqDxAJgVnvMRZpap3VQ3aOxLOWFjKL7Ha6jbywg=;
        b=AAa3SPnQ4yUnqv6T4LdxChe/+3Krwfhcf9XtcDyvJSEqh75tax8S08qt9cc665Hcp8CNpv
        s6F0OEUERIOo4ovGbKaLTJtAPiiHO2QOMxSdMMUK01ooou3rak/4hAbaZzOmjIJJPF+gJo
        XSSVCivSfX7ECT+6Uq+qAq+ubuO7raI=
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-459-_79iw8aOMtq7V-m9tHuvdg-1; Sat, 21 May 2022 04:51:23 -0400
X-MC-Unique: _79iw8aOMtq7V-m9tHuvdg-1
Received: by mail-pg1-f197.google.com with SMTP id f9-20020a636a09000000b003c61848e622so5279095pgc.0
        for <kvm@vger.kernel.org>; Sat, 21 May 2022 01:51:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=yx5IpqDxAJgVnvMRZpap3VQ3aOxLOWFjKL7Ha6jbywg=;
        b=gyY6nBuG4/Jq4WHOEtxTDI9o4MFVwzQPcxIb10uKoM4X1RKDVnMtpaHxu0uQe/L/dg
         I71PgRJNSnFuPyIZmXzuHJo/sDYn61sDxLAm02zAM5T5zzTUY0+7QoE91CvV4yC0UqD1
         0Y10EQYH5IoAP/zkjUlz/V+a6jDhGCy0Q+3HuqfCechw3wWhJWuUxi1QPyjcvtlChpWz
         6X7ZTQ1Qx5DCFJfwdjZQt7PUkYS31H2379CbxlaI6eGuQyLiOnV41yCcHuBIXaTkkTkY
         ULbd9FJaF/YouKAgakr29vrYHBjIF9Je5xWCWMCFbWtqa14izXCAKKI1SjwbPsaHSzg6
         qyFw==
X-Gm-Message-State: AOAM533P1+e+jwEhiFetk4X755w/3iFwikj/ZMbERD3ZnARQJ70mNHuK
        08XIlY9/hELGfvq0JiEf7aMthLTwOsTTDO9RnDcaK6M7Bok8hptolJrHsxefc6TjZrbufe8rve0
        myQ7e36smgE2j77Dv+wJS0AHlDv+t
X-Received: by 2002:a17:90a:d713:b0:1df:d114:deef with SMTP id y19-20020a17090ad71300b001dfd114deefmr14319469pju.13.1653123082150;
        Sat, 21 May 2022 01:51:22 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy/VttGO4R/Ibn0e9m4XtXrkS0y7WN5l5TiYeUveZaskc4plOnQZLMchX/7Jt+KPVOFVoinCkZeORznMjTd88A=
X-Received: by 2002:a17:90a:d713:b0:1df:d114:deef with SMTP id
 y19-20020a17090ad71300b001dfd114deefmr14319448pju.13.1653123081851; Sat, 21
 May 2022 01:51:21 -0700 (PDT)
MIME-Version: 1.0
From:   Paolo Bonzini <pbonzini@redhat.com>
Date:   Sat, 21 May 2022 10:51:10 +0200
Message-ID: <CABgObfYhg1ZttC=mcpHkJV6QuA1CimCJwYckS86sZz+vQDC4XA@mail.gmail.com>
Subject: Status for 5.19 merge window
To:     kvm <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Already merged for 5.19:
* Allow userspace to opt out of hypercall patching
* New ioctls to get/set TSC frequency for a whole VM
* Only do MSR filtering for MSRs accessed by rdmsr/wrmsr
* Nested virtualization improvements for AMD:
** Support for "nested nested" optimizations (nested vVMLOAD/VMSAVE,
nested vGIF)
** Allow AVIC to co-exist with a nested guest running
** Fixes for LBR virtualizations when a nested guest is running, and
nested LBR virtualization support
** PAUSE filtering for nested hypervisors
* In kernel Xen event channel delivery
* Fixes for AMD injection
* SEV improvements
** Add KVM_EXIT_SHUTDOWN metadata for SEV-ES
** V_TSC_AUX support
* CPU state/MMU role refactoring
* Fast page fault cleanups
* IPI virtualization
* Guest performance monitoring improvements:
** Support for PEBS
** Support for architectural LBR

Will be in 5.19 merge window:
* dirty quota
* nested dirty-log selftest

After merge window:
* APICv inhibition on APIC id change

Delayed to 5.20:
* eager page splitting
* CMCI support
* Hyper-V TLB
* pfn functions cleanup
* x2AVIC
* nested AVIC

