Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A5A76D487F
	for <lists+kvm@lfdr.de>; Mon,  3 Apr 2023 16:29:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233421AbjDCO3N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Apr 2023 10:29:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233395AbjDCO3K (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Apr 2023 10:29:10 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42194319BC;
        Mon,  3 Apr 2023 07:29:01 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id 2adb3069b0e04-4dd9da1c068so371235e87.0;
        Mon, 03 Apr 2023 07:29:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680532139;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hH1xosDA4fhxPoK+LaLX98KXIgYzN1S+FW0AjfW+bw8=;
        b=CAME34HW9yFFaJHZ7ULEfnMwvsZan4hJr/ZWDR0xLha3apQc4IwWKETlrVaghgt3xV
         UcrRmDrBUKo6ZvmtXsxFUdRjsQQbMhcYmox/0cgbME+IsDzoQKBuZE+q9SbI2cl6WjTH
         BaHJ4Su3vP/mRlhn1hahIYdSB1Os23zS4bJIl0txBDlLofBY9pWfudKY/tHYtYWeq29w
         ojH1l0firSySGu7uB8pL3nL+SXJhOrGJhC4QAsUEypA80pcWRhPSFFr6PBIwib4klKgd
         ko0SS7GdkCEdOGVbVKDy/atEw8D7vrKRZ8hr4RNqUkDmPBx/JqUnfNf4M46PwK6TugRy
         c5yQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680532139;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hH1xosDA4fhxPoK+LaLX98KXIgYzN1S+FW0AjfW+bw8=;
        b=ihIggqbsIm2Vsvq1l5sUQa3SBQ2n5GlTCm5KEru/P2O2l/mJcLxrWUwSSplFFs9UAf
         OH/wknqa9dJQMZDLl8S9ZVxYuzY+ortdX+glQsLPzIeo802m8zSJ11K0OaqkpL3bFj/w
         5GTCRLaxZqSaNl30ni/UXVFqZhmqB5GF7otQ9sYSH7Q59gKP1jp6OuFVPJtzadmQqjNc
         KRY1DvsUJavGgv9wattuGHtfl9IUtdt3xyIIuL3dwf4wN7ZhgYRbr+MCoy+bI+cvJ8dq
         UAzBIjvlIOU6ZinU4rC4rIihMRhByoiP7EbrCRqo8KrUywsd4kmIRvArPTVHP7r49XWT
         QwfQ==
X-Gm-Message-State: AAQBX9eD+0htD9mpJXkwegnR6/9LzH8BTOr8t7HJcZ/z5iIJaavy1Dlp
        9EzmYo7Ui47LY/3abKRVNYA=
X-Google-Smtp-Source: AKy350YF5i/5sBNYuDwYsmDiEF88n9U1aGk+Td/cMo45pIqZYBQbsV5uAGFuQuFaFQcInSzohbWsdw==
X-Received: by 2002:a05:651c:2128:b0:295:a024:f3e2 with SMTP id a40-20020a05651c212800b00295a024f3e2mr5011799ljq.5.1680532139341;
        Mon, 03 Apr 2023 07:28:59 -0700 (PDT)
Received: from localhost (88-115-161-74.elisa-laajakaista.fi. [88.115.161.74])
        by smtp.gmail.com with ESMTPSA id h7-20020a2e3a07000000b00299f0194108sm1782309lja.31.2023.04.03.07.28.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Apr 2023 07:28:59 -0700 (PDT)
Date:   Mon, 3 Apr 2023 17:28:35 +0300
From:   Zhi Wang <zhi.wang.linux@gmail.com>
To:     Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     Isaku Yamahata <isaku.yamahata@gmail.com>,
        isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [PATCH v13 016/113] KVM: TDX: x86: Add ioctl to get TDX
 systemwide parameters
Message-ID: <20230403172835.000040eb.zhi.wang.linux@gmail.com>
In-Reply-To: <24ddf589-34a4-b312-72c1-8176ee3e8b35@intel.com>
References: <cover.1678643051.git.isaku.yamahata@intel.com>
        <cb0ae8b4941aaa45e1e5856dde644f9b2f53d9a6.1678643052.git.isaku.yamahata@intel.com>
        <20230325104306.00004585@gmail.com>
        <20230329231722.GA1108448@ls.amr.corp.intel.com>
        <20230331001803.GE1112017@ls.amr.corp.intel.com>
        <20230331154432.00001373@gmail.com>
        <24ddf589-34a4-b312-72c1-8176ee3e8b35@intel.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 3 Apr 2023 11:46:15 +0800
Xiaoyao Li <xiaoyao.li@intel.com> wrote:

> On 3/31/2023 8:44 PM, Zhi Wang wrote:
> > On Thu, 30 Mar 2023 17:18:03 -0700
> > Isaku Yamahata <isaku.yamahata@gmail.com> wrote:
> > 
> >> On Wed, Mar 29, 2023 at 04:17:22PM -0700,
> >> Isaku Yamahata <isaku.yamahata@gmail.com> wrote:
> >>
> >>> On Sat, Mar 25, 2023 at 10:43:06AM +0200,
> >>> Zhi Wang <zhi.wang.linux@gmail.com> wrote:
> >>>
> >>>> On Sun, 12 Mar 2023 10:55:40 -0700
> >>>> isaku.yamahata@intel.com wrote:
> >>>>
> >>>> Does this have to be a new generic ioctl with a dedicated new x86_ops? SNP
> >>>> does not use it at all and all the system-scoped ioctl of SNP going through
> >>>> the CCP driver. So getting system-scope information of TDX/SNP will end up
> >>>> differently.
> >>>>
> >>>> Any thought, Sean? Moving getting SNP system-wide information to
> >>>> KVM dev ioctl seems not ideal and TDX does not have a dedicated driver like
> >>>> CCP. Maybe make this ioctl TDX-specific? KVM_TDX_DEV_OP?
> >>>
> >>> We only need global parameters of the TDX module, and we don't interact with TDX
> >>> module at this point.  One alternative is to export those parameters via sysfs.
> >>> Also the existence of the sysfs node indicates that the TDX module is
> >>> loaded(initialized?) or not in addition to boot log.  Thus we can drop system
> >>> scope one.
> >>> What do you think?
> >>>
> > 
> > I like this idea and the patch below, it feels right for me now. It would be nice
> > if more folks can chime in and comment.
> 
> SYSFS option requires CONFIG_SYSFS, which reqiures CONFIG_KVM_TDX to 
> select CONFIG_SYSFS.
> 
> >>> Regarding to other TDX KVM specific ioctls (KVM_TDX_INIT_VM, KVM_TDX_INIT_VCPU,
> >>> KVM_TDX_INIT_MEM_REGION, and KVM_TDX_FINALIZE_VM), they are specific to KVM.  So
> >>> I don't think it can be split out to independent driver.
> >>
> > 
> > They can stay in KVM as they are KVM-specific. SNP also has KVM-specific ioctls
> > which wraps the SEV driver calls. At this level, both TDX and SNP go their specific
> > implementation without more abstraction other than KVM_ENCRYPT_MEMORY_OP. Their
> > strategies are aligned.
> > 
> > The problem of the previous approach was the abstraction that no other implementation
> > is using it. It is like, TDX wants a higher abstraction to cover both TDX and SNP,
> > but SNP is not using it, which makes the abstraction looks strange.
> 
> Note, before this TDX enabling series, KVM_MEMORY_ENCRYPT_OP is a VM 
> scope ioctl, that only serves for SEV and no other implementation uses 
> it. I see no reason why cannot introduce a new IOCTL in x86 KVM that 
> serves only one vendor.
> 

My point is: time is different. When KVM_MEMORY_ENCRYPT_OP is there,
there was *only* one vendor and SEV/SNP didn't know how the future vendor
is going to use the ioctl. That is a reasonable case an generic ioctl can
have one vendor to back up.

The background here is: now another vendor is coming and there are going to
be two vendors. The two vendors' flows are much clearer than early stage.
Like, they know which flow is going to be used by each other.

With these kept in mind, IMHO, it is not appropriate to introduce
an generic ioctl that only one vendor is going to use, meanwhile
we have already known another vendor is not going to use it.

Defining a new userspace ABI is a serious thing and it is not an early
stage anymore. Actually I think it is the best time to see how the
code infrastructure should be re-purposed at this time. 

> We choose KVM_MEMORY_ENCRYPT_OP for TDX platform scope, just because we 
> reuse KVM_MEMORY_ENCRYPT_OP for TDX VM-scope and extend it to TDX vcpu 
> scope. It's just to avoid defining a new IOCTL number.
> 
> We can rename it to KVM_GET_CC_CAPABILITIES, and even return different 
> capabilities based on VM type. And even, if SNP wants to use it, I think 
> it can wrap SNP driver calls inside this IOCTL?
> 

I am not opposed to this option as it shows effort to improve it and it
is constructive. But this needs to be figured out with AMD folks and
maintainers. E.g. what should be the best CC ioctl scheme for KVM?
vendor-specific or generic, which brings better benefit for the userspace,
and less maintenance burden.

Back to the reason why I think a vendor-specific sysinfo interface for TDX
is necessary:

1) SEV driver has been there for quite some time. Unless people thinks an
generic CC ioctl scheme is a way to go, then there will be motivation and
efforts putting on it. The efforts is not only about wrapping SEV ioctls,
it needs a systematic spec of generic CC ioctl scheme. 

2) TDX doesn't have a driver like SEV and possibly not going to have one in
the future. For those non-KVM related control flow of TDX in future, they
can re-use this and stay away from KVM interface. (If vendor-specific
scheme is the future direction.)

> kvm.ko is special that it needs to serve two vendors. Sometime it's 
> unaviodable that an interface is only used by one vendor.

I am afraid that in this case it is avoidable right?
