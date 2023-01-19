Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AD5D674071
	for <lists+kvm@lfdr.de>; Thu, 19 Jan 2023 19:02:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230316AbjASSCM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Jan 2023 13:02:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229614AbjASSCI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Jan 2023 13:02:08 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04BD790B1E
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 10:01:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674151278;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=OCYQDSCARx+Agjp+r9qcmqIzKDtZf4s4XuGktFSZMXo=;
        b=Ddd0XJ+AUvACUNRVMR8cR7v0MLZ9hgUa1b7wHjv+nxL3ISQzDR4MUh9p2LdOufuHdsleEM
        4wpiTSMUKGZbP+Kfm0cLMbDD/ic2ywUMYwUlVcVneBcnEtUoh/j2+qdhFUSGf/2CVYlx9M
        BcFPUD/wuNr0u3IfjhlNuwJ0/U3ghks=
Received: from mail-vk1-f200.google.com (mail-vk1-f200.google.com
 [209.85.221.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-593-KzuLOQWkOUOn7FX1eysSnQ-1; Thu, 19 Jan 2023 13:01:16 -0500
X-MC-Unique: KzuLOQWkOUOn7FX1eysSnQ-1
Received: by mail-vk1-f200.google.com with SMTP id y3-20020a1f3203000000b003e1c75290f1so843163vky.12
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 10:01:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OCYQDSCARx+Agjp+r9qcmqIzKDtZf4s4XuGktFSZMXo=;
        b=clPRh7M6dRy+yal+dq7/NtF8zYBVN85D5W+v8Eg7baVUURvevtjOVjp//x+gN0u1XV
         aHormtMisINBNn3TXh/aSvqGvvcVyYZYS38t4ovI19KzFZG55lnvsDs4wBPh+Hd17GGq
         QzIFTBg9nWHfQm2Mq+IX4DW5hlS8eN0KRdAx5sp0SxV1Au+zRhQWnFczBoHMH8aAYdIy
         +cBEOWwi+Cj8GAmE0tFOjNThsZyQ4qrYnjPd4Ix1xd65jygeaMSUwoWdlJvZvLPfzwUS
         5YLb9CTOQUyguaSk1M7puj+ceT+QY+Tq0Ip5yjqB9xe3nwJliVAriAORQetPPDD0z4Qh
         9byA==
X-Gm-Message-State: AFqh2kr1skOxBSI6UnskCIp5drEriq2OmsBeeBt+sofEBeC3X9TQHUja
        Gi5S+jJC9vcfV0tYrJqM26EY8lxaTneHSbeXOmMOfWwLymhiKjqgbW+dAKApm8o7DdeceVArs5J
        i286tu0NCuM9xfUOpyLDzmci9oKl+
X-Received: by 2002:a67:d89d:0:b0:3d3:d0d4:b250 with SMTP id f29-20020a67d89d000000b003d3d0d4b250mr1718516vsj.27.1674151275817;
        Thu, 19 Jan 2023 10:01:15 -0800 (PST)
X-Google-Smtp-Source: AMrXdXur01K2e5gOZ56JeXudRHiooMADi6Y0Y3bMZzeW/UtSWAIqdrDLx4FNEJ5NYvmryWXNYMwW3deO/fph7eH0Kzo=
X-Received: by 2002:a67:d89d:0:b0:3d3:d0d4:b250 with SMTP id
 f29-20020a67d89d000000b003d3d0d4b250mr1718509vsj.27.1674151275576; Thu, 19
 Jan 2023 10:01:15 -0800 (PST)
MIME-Version: 1.0
References: <20221228110410.1682852-1-pbonzini@redhat.com> <20230119155800.fiypvvzoalnfavse@linux.intel.com>
 <Y8mEmSESlcdgtVg4@google.com>
In-Reply-To: <Y8mEmSESlcdgtVg4@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Date:   Thu, 19 Jan 2023 19:00:23 +0100
Message-ID: <CABgObfb6Z2MkG8yYtbObK4bhAD_1s8Q_M=PnP5pF-sk3=w8XDg@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86: fix deadlock for KVM_XEN_EVTCHN_RESET
To:     Sean Christopherson <seanjc@google.com>
Cc:     Yu Zhang <yu.c.zhang@linux.intel.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Michal Luczaj <mhal@rbox.co>,
        David Woodhouse <dwmw@amazon.co.uk>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 19, 2023 at 6:57 PM Sean Christopherson <seanjc@google.com> wrote:
> > This change generates a build failure with error message:
> > "error: a label can only be part of a statement and a declaration is not a statement".
>
> And other flavors too, e.g.
>
> x86_64/xen_shinfo_test.c:965:2: error: expected expression
>         struct kvm_xen_hvm_attr evt_reset = {
>         ^
> x86_64/xen_shinfo_test.c:969:38: error: use of undeclared identifier 'evt_reset'
>         vm_ioctl(vm, KVM_XEN_HVM_SET_ATTR, &evt_reset);
>                                             ^
> x86_64/xen_shinfo_test.c:969:38: error: use of undeclared identifier 'evt_reset'
> 3 errors generated.
> make: *** [../lib.mk:145: tools/testing/selftests/kvm/x86_64/xen_shinfo_test] Error 1
> make: *** Waiting for unfinished jobs....
>
> I'm surprised bots haven't complained about this, haven't seen any reports.

It's clang only; GCC only warns with -Wpedantic. Plus, bots probably
don't compile tools/ that much.

Paolo

