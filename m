Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 728F95A8339
	for <lists+kvm@lfdr.de>; Wed, 31 Aug 2022 18:30:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231910AbiHaQaA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Aug 2022 12:30:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231407AbiHaQ36 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Aug 2022 12:29:58 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 747C9D99C9
        for <kvm@vger.kernel.org>; Wed, 31 Aug 2022 09:29:26 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id fa2so6944340pjb.2
        for <kvm@vger.kernel.org>; Wed, 31 Aug 2022 09:29:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=ai3kla76noYultWIeYF2au+T/PVC036OnJ9JVKMm/v8=;
        b=YhZUMHTa6jXt5s3IV+ImLKAXUKEH11NrF2K3Q2AOqc/mZ/mRMdbl6ivOPpSiMo5ZEa
         WzKQ//BC6APOQKz42cf11UJcJD3PO2Sx5hgaIGP+tsnTGBifWStyIr7y4oJUmhqlXXpA
         h2EkthNjTOne+KDvXveKoKZk/qZdo+zEaFlw/Uubn+NB5MEtcjD9dWF5xRJQeAvTvYd/
         23KuedK/J/ZgS9guVkqbwimTDhLWHu/xtvmZfTdslTdQ3osyc0zEO6bOn7IzHOwTN63A
         QwTIeDln4yXp2OgWI5RGppw2ICabisK6op1cK/eNK5KgkJ4DQiQNF2aYeo+UsQEjKLzC
         2XYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=ai3kla76noYultWIeYF2au+T/PVC036OnJ9JVKMm/v8=;
        b=Mr7ATE6TFCrZtE7NDbMk5MHG+vZHFMJuYxoTLn35FdzfHCN0aSQ2iAaFXxQvVJOVmT
         p9Qaqt2yzYCZDRjZF5Ss4D7kdXKsT8Bk9vrpV1Fd7mCB7BLq9jBUnSIXk6c7mHRUKAVV
         mVao8ljGixZpoRi+n3sn5mPRN/H5tj0Z9Db/PGFzuPy7eAk+3ax9ne/c+gHHQUzEVvuH
         P7Vcy5HboEhsoYNpOREkSYqKvApD9dAgRQeK09UklzBwFCowrngYUI0zTq1MAAau5QvG
         vmIvKXk7TolVho9+1lsksFC9nB6rdhHSIG99CmMlxHHvqOZxjZ5aT+k4ZwIXNG2Kjj68
         5MPg==
X-Gm-Message-State: ACgBeo0ei84s31RVzW76EerurNb2Dk1w0CFTDuhED9NpbyMFmK7ntwOX
        y4E9QN2fojU9kY5fhb7rryhcgw==
X-Google-Smtp-Source: AA6agR6lKjEFhC6HcrUUPmR6ex01FcrgT0C94jGiCFsQOzdOxbYF0sRHpOheCNhe44lAF2Xzey3eQw==
X-Received: by 2002:a17:90b:1b49:b0:1fd:dccc:91f7 with SMTP id nv9-20020a17090b1b4900b001fddccc91f7mr4056962pjb.200.1661963365688;
        Wed, 31 Aug 2022 09:29:25 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id u11-20020a170902e80b00b001744171a60esm10160498plg.194.2022.08.31.09.29.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Aug 2022 09:29:25 -0700 (PDT)
Date:   Wed, 31 Aug 2022 16:29:20 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Li RongQing <lirongqing@baidu.com>
Subject: Re: [PATCH 03/19] Revert "KVM: SVM: Introduce hybrid-AVIC mode"
Message-ID: <Yw+MYLyVXvxmbIRY@google.com>
References: <20220831003506.4117148-1-seanjc@google.com>
 <20220831003506.4117148-4-seanjc@google.com>
 <17e776dccf01e03bce1356beb8db0741e2a13d9a.camel@redhat.com>
 <84c2e836d6ba4eae9fa20329bcbc1d19f8134b0f.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84c2e836d6ba4eae9fa20329bcbc1d19f8134b0f.camel@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 31, 2022, Maxim Levitsky wrote:
> On Wed, 2022-08-31 at 08:59 +0300, Maxim Levitsky wrote:
> > On Wed, 2022-08-31 at 00:34 +0000, Sean Christopherson wrote:
> > > Remove SVM's so called "hybrid-AVIC mode" and reinstate the restriction
> > > where AVIC is disabled if x2APIC is enabled.  The argument that the
> > > "guest is not supposed to access xAPIC mmio when uses x2APIC" is flat out
> > > wrong.  Activating x2APIC completely disables the xAPIC MMIO region,
> > > there is nothing that says the guest must not access that address.
> > > 
> > > Concretely, KVM-Unit-Test's existing "apic" test fails the subtests that
> > > expect accesses to the APIC base region to not be emulated when x2APIC is
> > > enabled.
> > > 
> > > Furthermore, allowing the guest to trigger MMIO emulation in a mode where
> > > KVM doesn't expect such emulation to occur is all kinds of dangerous.
> 
> Also, unless I misunderstood you, the above statement is wrong.
> 
> Leaving AVIC on, when vCPU is in x2apic mode cannot trigger extra MMIO emulation,
> in fact the opposite - because AVIC is on, writes to 0xFEE00xxx might *not* trigger
> MMIO emulation and instead be emulated by AVIC.

That's even worse, because KVM is allowing the guest to exercise hardware logic
that I highly doubt AMD has thoroughly tested.

> Yes, some of these writes can trigger AVIC specific emulation vm exits, but they
> are literaly the same as those used by x2avic, and it is really hard to see
> why this would be dangerous (assuming that x2avic code works, and avic code
> is aware of this 'hybrid' mode).

The APIC_RRR thing triggered the KVM_BUG_ON() in kvm_apic_write_nodecode()
precisely because of the AVIC trap.  At best, this gives a way for the guest to
trigger a WARN_ON_ONCE() and thus panic the host if panic_on_warn=1.  I fixed
the APIC_RRR case because that will be problematic for x2AVIC, but there are
other APIC registers that are unsupported in x2APIC that can trigger the KVM_BUG_ON().

> From the guest point of view, unless the guest pokes at random MMIO area,
> the only case when this matters is if the guest maps RAM over the 0xFEE00xxx
> (which it of course can, the spec explictly state as you say that when x2apic
> is enabled, the mmio is disabled), and then instead of functioning as RAM,
> the range will still function as APIC.

There is no wiggle room here though, KVM is blatantly breaking the architectural
specification.  When x2APIC is enabled, the xAPIC MMIO does not exist.
