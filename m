Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 788AB660AF0
	for <lists+kvm@lfdr.de>; Sat,  7 Jan 2023 01:37:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231395AbjAGAhE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Jan 2023 19:37:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236290AbjAGAfZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Jan 2023 19:35:25 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E69040C29
        for <kvm@vger.kernel.org>; Fri,  6 Jan 2023 16:35:10 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id n12so3118013pjp.1
        for <kvm@vger.kernel.org>; Fri, 06 Jan 2023 16:35:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=bXq8vuFGGvOv35bUy+EyGeh26Ce9kmE/NPpZHF2+yik=;
        b=GaHAV5OSUosgIlhbKZU0knGkSBuNcrmEFL/MxpfoPWY1CY5AWTrAwmFY0YO0XFktYw
         24wDdthRmLVjKLr6ncoOAHj3H2HawsueKzAAoarsWnr2MOvfeXcx/MbEkMjNI1qxc6a7
         2BnfFkauOk0LY/gA0DhCuxK9FC2kYZjlPyCn5NadOoQj3ViiupRr/VZKuuCi3NbJqgqM
         J8iC0n+suOpfUTw7C7hr1jvU4Qpz1Yv3g6MG3Cw6kH8+qnUhTBN+1C4Si6k4KC1VPiN8
         Lpd0RMhB5wkSgjY2JOz+/882WwSErSfZwhdA6enf7DzED/DHX2svcLiL3vAcl9Q2zXzc
         zcbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bXq8vuFGGvOv35bUy+EyGeh26Ce9kmE/NPpZHF2+yik=;
        b=Mwpf0QQPz81pjF90T1i3Ujl/D1zZszCJ17q5L6czCsRyEdSSGjZvibn8TNNgVvv9VU
         lm0az9hPDN2IwWeeXzCcN4Esj6EqVOagU3cgVETJMpvMxOLMD/UvWLahOq7FTBwOf7P4
         Hs9Xyuo3mz/aHoDImr8oZ2tT+E+mLCU2OF6TfMpqnU7qThsLlbinny32R0Yb8HmMsYWw
         vYwdDiN44mlXSUq+pv1NOdObzcTPbKg4E24axGmGutnoCBNlpRRh4d1H6brGANCJQSlC
         32nSovWcAgzd6XRbap7W6tF5Tap0Ufw4obrcgJxvdDqPk2Qk1S5Lj0T5awHWv43ukYZO
         fSbA==
X-Gm-Message-State: AFqh2kqi6Z8ZBWV6q7AXtDf2DVgRz4tcL3HelTHiq2ycbVY12IMiDLdp
        ETEbVlH8K6tpf+H2N+pb2eHOVQ==
X-Google-Smtp-Source: AMrXdXvf8PJ2X/dRmbdsw9QNylVEJi8QMlZUpl9k+2tYEh64CIJy7JUPttqUClq+ntDxGPgAumLKaw==
X-Received: by 2002:a17:902:820e:b0:189:6624:58c0 with SMTP id x14-20020a170902820e00b00189662458c0mr3784pln.3.1673051709529;
        Fri, 06 Jan 2023 16:35:09 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id s6-20020a170902ea0600b001913c5fc051sm1438523plg.274.2023.01.06.16.35.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Jan 2023 16:35:09 -0800 (PST)
Date:   Sat, 7 Jan 2023 00:35:05 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Robert Hoo <robert.hu@linux.intel.com>
Cc:     Binbin Wu <binbin.wu@linux.intel.com>, pbonzini@redhat.com,
        kirill.shutemov@linux.intel.com, kvm@vger.kernel.org
Subject: Re: [PATCH v3 1/9] KVM: x86: Rename cr4_reserved/rsvd_* variables to
 be more readable
Message-ID: <Y7i+OW+8p7Ehlh3C@google.com>
References: <20221209044557.1496580-1-robert.hu@linux.intel.com>
 <20221209044557.1496580-2-robert.hu@linux.intel.com>
 <2e395a24-ee7b-e31e-981c-b83e80ac5be1@linux.intel.com>
 <b8f8f8acb6348ad5789fc1df6a6c18b0fa5f91ee.camel@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b8f8f8acb6348ad5789fc1df6a6c18b0fa5f91ee.camel@linux.intel.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Dec 29, 2022, Robert Hoo wrote:
> On Wed, 2022-12-28 at 11:37 +0800, Binbin Wu wrote:
> > On 12/9/2022 12:45 PM, Robert Hoo wrote:
> > > kvm_vcpu_arch::cr4_guest_owned_bits and
> > > kvm_vcpu_arch::cr4_guest_rsvd_bits
> > > looks confusing. Rename latter to cr4_host_rsvd_bits, because it in
> > > fact decribes the effective host reserved cr4 bits from the vcpu's
> > > perspective.
> > 
> > IMO, the current name cr4_guest_rsvd_bits is OK becuase it shows that these
> > bits are reserved bits from the pointview of guest.
> 
> Actually, it's cr4_guest_owned_bits that from the perspective of guest.

No, cr4_guest_owned_bits is KVM's view of things.  It tracks which bits have
effectively been passed through to the guest and so need to be read out of the
VMCS after running the vCPU.

> cr4_guest_owned_bits and cr4_guest_rsvd_bits together looks quite
> confusing.

I disagree, KVM (and the SDM and the APM) uses "reserved" or "rsvd" all over the
place to indicate reserved bits/values/fields.

> > > * cr4_reserved_bits --> cr4_kvm_reserved_bits, which describes

Hard no.  They aren't just KVM reserved, many of those bits are reserved by
hardware, which is 100% dependent on the host.

> > > CR4_HOST_RESERVED_BITS + !kvm_cap_has() = kvm level cr4 reserved
> > > bits.
> > > 
> > > * __cr4_reserved_bits() --> __cr4_calc_reserved_bits(), which to
> > > calc
> > > effective cr4 reserved bits for kvm or vm level, by corresponding
> > > x_cpu_has() input.
> > > 
> > > Thus, by these renames, the hierarchical relations of those reserved CR4
> > > bits is more clear.

Sorry, but I don't like any of the changes in this patch.  At best, some of the
changes are a wash (neither better nor worse), and in that case the churn, however
minor isn't worth it.
