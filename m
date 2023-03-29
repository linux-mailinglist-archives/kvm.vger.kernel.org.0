Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 767C26CEF8E
	for <lists+kvm@lfdr.de>; Wed, 29 Mar 2023 18:36:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229802AbjC2QgG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Mar 2023 12:36:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230057AbjC2QgE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Mar 2023 12:36:04 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93C203A8E
        for <kvm@vger.kernel.org>; Wed, 29 Mar 2023 09:36:02 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id b16-20020a17090a991000b0023f803081beso4796755pjp.3
        for <kvm@vger.kernel.org>; Wed, 29 Mar 2023 09:36:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680107762;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=zWSaOtnT1PTd7puap+PC7Myxa3v4DAzj/2jnrgYrQ/M=;
        b=NV4wUr7VSCkAVWSBOqjxzW7g7vjgfu7fGth7twe8wglJFD5HnH/G6oYLO/l8gvQRdI
         Vd6uYB04aNiLENuMnYzggnHbTk2LppjJb4Xkom+UFUkGnlZfx/3YWZp/741KyTlcyf9n
         /emN4QC5YJ8SANFisjXXd8+zDFlTFkN05Y0RKZJWYQN6wt/4v/8lUbNlIO+uXQtfrZPe
         2u3ChU7xUAWvzTiBN81/Ze8Vf1v2IsPVBDjED0RCjjPNOoDZUXfHpES3HnqgaWTBYvTQ
         ueK/+ASFtHKpDrG4ThMqgqhQda+W9zkLncWahkpdOEyg6khQ9ABsHH8wMrotdUAh9JgM
         edgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680107762;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zWSaOtnT1PTd7puap+PC7Myxa3v4DAzj/2jnrgYrQ/M=;
        b=weo4EOIaF1WK0AsRqc3xZA32wmTNZ4B/7Aq+43S1ljBHqUr+7Lch0RlFIRDur8HoD0
         XYcsRS1JjTOmU/SzOBCIYbV5aDaRGCDaMqnFnQQ+D/68P8/Ucvd31Z3J53pB9i/svU9u
         OPIHKAWe1RpsZaFpJIj7etpU0diZSV/jhWR3fXCcYpuXxYf9LCiVb1Aq1n6Q8LA4yIl8
         aUX7Dxp7QLDnuQUNuahm8oUCS+EEN4rklHy3/G5SgKxzCT8dW3PddAhhM2bL5wNrL4F9
         KIyC1JAxg50rGF+acZT2W2oNZjZHFkxDzu6aI7pBXZsuQoRzpD8+Vng1DLBga3YVWjag
         OD6Q==
X-Gm-Message-State: AAQBX9egqClySmoqZii4Nsa/rXtNMSG0crt6lajgntoAMiHmVFC0OjX1
        +A8Q9qUjWoTz80QamDYXcAjeyCGYGbQ=
X-Google-Smtp-Source: AKy350aS1Vd1r4LL3/gWrKpPneGUgNOecf1ruYPUYjwZOi9+vXFy25Qrt/XjDKbCNdE3OgJThSo2CkmdsyA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:bf16:b0:23d:20c:2065 with SMTP id
 c22-20020a17090abf1600b0023d020c2065mr1057847pjs.1.1680107762120; Wed, 29 Mar
 2023 09:36:02 -0700 (PDT)
Date:   Wed, 29 Mar 2023 09:36:00 -0700
In-Reply-To: <05792cbd-7fdb-6bf2-ebaa-9d13a2c4fddd@intel.com>
Mime-Version: 1.0
References: <20230328050231.3008531-1-seanjc@google.com> <20230328050231.3008531-2-seanjc@google.com>
 <620935f7-dd7a-2db6-1ddf-8dae27326f60@intel.com> <ZCMCzpAkGV56+ZbS@google.com>
 <05792cbd-7fdb-6bf2-ebaa-9d13a2c4fddd@intel.com>
Message-ID: <ZCRogsvUYMQV6kca@google.com>
Subject: Re: [kvm-unit-tests PATCH 1/3] x86: Add define for
 MSR_IA32_PRED_CMD's PRED_CMD_IBPB (bit 0)
From:   Sean Christopherson <seanjc@google.com>
To:     Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 29, 2023, Xiaoyao Li wrote:
> On 3/28/2023 11:07 PM, Sean Christopherson wrote:
> > On Tue, Mar 28, 2023, Xiaoyao Li wrote:
> > > On 3/28/2023 1:02 PM, Sean Christopherson wrote:
> > > > Add a define for PRED_CMD_IBPB and use it to replace the open coded '1' in
> > > > the nVMX library.
> > > 
> > > What does nVMX mean here?
> > 
> > Nested VMX.  From KUT's perspective, the testing exists to validate KVM's nested
> > VMX implementation.  If it's at all confusing, I'll drop the 'n'  And we've already
> > established that KUT can be used on bare metal, even if that's not the primary use
> > case.
> 
> So vmexit.flat is supposed to be ran in L1 VM?

Not all of the tests can be run on bare metal, e.g. I can't imagine the VMware
backdoor test works either.

> I'm confused and interested in how KUT is used on bare metal.

I haven't used KUT on bare metal myself, but the idea is pretty much the same as
running under QEMU/KVM: boot into the KUT "kernel" after getting through firmwrae
instead of transferring control to an actual OS.  I assume the biggest challenges
are getting the image loaded, and getting info out of KUT, e.g. having a serial
port with something on the backend to capture/display output.
