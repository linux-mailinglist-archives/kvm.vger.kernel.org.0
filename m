Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 581EE73E508
	for <lists+kvm@lfdr.de>; Mon, 26 Jun 2023 18:29:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230104AbjFZQ3n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Jun 2023 12:29:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229989AbjFZQ3Z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Jun 2023 12:29:25 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A19BE10F
        for <kvm@vger.kernel.org>; Mon, 26 Jun 2023 09:28:26 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id 41be03b00d2f7-53fa2d0c2ebso1421264a12.1
        for <kvm@vger.kernel.org>; Mon, 26 Jun 2023 09:28:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1687796906; x=1690388906;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=LcHOcPJNQNsmb8p5lWxRB01eVrgr+kLMT1qIAAPh7K0=;
        b=0C+CyWG0GM0drwvZ0vSkvRMtOSGBuPAKMRT9q9dRUNLgsTmg4HKMwjYpYcDTv57Tls
         zSJGXTxI6enbEMjyacQKdeUQcj8wenqCDj2auDP4WOwTdqv2mkFXXqtCw4dMrc+GL4UZ
         jMIwhWZ4zIFfAKfoAP3ki2pyE1yo3gcNAKNksNqGCMY5cPjA26nOLRCRSKzJhhet5mWN
         Lj+T5CX9IyCLMiU4f1sJFb9xKm6JQ+02iH15WBZYqIissVx0r560CxYKbPw7/cXX53LO
         9dXRlcIb47Yj3OJ4myuWHzraEWB281b77yaf5mLKXXkCsUj10GzQiqE/oeSurlo+Yjsv
         Or9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687796906; x=1690388906;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LcHOcPJNQNsmb8p5lWxRB01eVrgr+kLMT1qIAAPh7K0=;
        b=gw3INYNQiNOIKNH/HjiYjxQgRQ8UNlQ0lPYOrde6d0xUC7GRMAQY2cFfgGEbv0PoFO
         ftByoXptFfGsvj0DCTG/bGb3tfl+Ar/uM66IpxGh9FCdM0/rchFazwAOUABvsY5YbPNB
         7CmX84wTj3PQZUd0O/ZPncZ8RjG76eykfgsg6vDx9Y8OKwd4pin5wbk9nidQ302oMYhC
         2fbjSkCtEK2HaoSG/6nCdVO4t4DchVEUD4yCx8tS6vFWsfQpgNgqW6rXeweAAOaXcXCQ
         bXjOKxA1IxqEY0525Isxe3kGCT5IUaG4/OzcdZS3oNYeJEewsAukOSIh7KanPx/M4ff1
         BllA==
X-Gm-Message-State: AC+VfDw/iEZ1R1dep4+N9qH9+40bd4v3Z5mWLP9DeW71NJEWzjPNSInC
        U8jKStPw8eGaoilyUg5W0MqzVPDaHJw=
X-Google-Smtp-Source: ACHHUZ7Wk6snFRWIjCiJHNIBQLZ/Mb6v/fisOviOSg2CIlQCenmsh0/FaAZPBkXB3y1IHQ/hHD+ZHUSwhWE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:d244:0:b0:540:ca81:4a1d with SMTP id
 t4-20020a63d244000000b00540ca814a1dmr3818129pgi.11.1687796906100; Mon, 26 Jun
 2023 09:28:26 -0700 (PDT)
Date:   Mon, 26 Jun 2023 09:28:24 -0700
In-Reply-To: <52ea8386-8652-dd91-23de-9d35781cb131@amd.com>
Mime-Version: 1.0
References: <20230524155339.415820-1-john.allen@amd.com> <20230524155339.415820-7-john.allen@amd.com>
 <161174d013dff42ddfd2950fe33a8054f45c223e.camel@intel.com>
 <ZINGaJnNJ54+klsD@johallen-workstation.lan> <9ef2faeaa38e667bd4daa8ee338d4cade452c76c.camel@intel.com>
 <ZJYaNSzup+yuYxNy@google.com> <52ea8386-8652-dd91-23de-9d35781cb131@amd.com>
Message-ID: <ZJm64a7IKuSDS9bz@google.com>
Subject: Re: [RFC PATCH v2 6/6] KVM: SVM: Add CET features to supported_xss
From:   Sean Christopherson <seanjc@google.com>
To:     Tom Lendacky <thomas.lendacky@amd.com>
Cc:     Rick P Edgecombe <rick.p.edgecombe@intel.com>,
        "john.allen@amd.com" <john.allen@amd.com>,
        Weijiang Yang <weijiang.yang@intel.com>,
        "bp@alien8.de" <bp@alien8.de>, "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "andrew.cooper3@citrix.com" <andrew.cooper3@citrix.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 26, 2023, Tom Lendacky wrote:
> On 6/23/23 17:18, Sean Christopherson wrote:
> > On Fri, Jun 09, 2023, Rick P Edgecombe wrote:
> > > Also, since the host might have CR4.CET set for its own reasons, if the host
> > > handled an exit with the the guests MSR_IA32_S_CET set it could suddenly be
> > > subjected to CET enforcement that it doesn't expect. Waiting to restore it
> > > until returning to the guest is too late.
> > > 
> > > At least that's the reasoning on the VMX side as I understand it
> > 
> > The APM doesn't come right out and say it, but I assume/hope that S_CET is saved
> > on VMRUN and loaded on #VMEXIT, i.e. is the same as VMX for all intents and
> > purposes.
> > 
> > The host save state definitely has a field for S_CET, and VMRUN documents that the
> > guest values are loaded, I just can't find anything in the APM that explicitly states
> > how host S_CET and friends are handled.  E.g. in theory, they could have been
> > shoved into VMSAVE+VMLOAD, though I very much doubt that's the case.
> 
> Yes, the host value is saved/restored on VMRUN/#VMEXIT. Anything that is in
> the VMCB Save Area (the non-SEV-ES save area) is fully virtualized (unless
> noted otherwise) and doesn't require special processing to save/restore the
> host values.

Would it makes sense to add a column in "Table B-2. VMCB Layout, State Save Area"
to specify whether a field is handled by VMRUN+#VMEXIT vs. VMLOAD+VMSAVE?  I can't
find anywhere in the APM where it explicitly states that VMRUN+#VMEXIT context
switches everything in the Save Area except the fields listed in "15.5.2 VMSAVE
and VMLOAD Instructions".

"15.5 VMRUN Instruction" kinda sorta covers that behavior, but the information is
either incomplete or stale, e.g. for host state it says "at least the following"

  Saving Host State. To ensure that the host can resume operation after #VMEXIT,
  VMRUN saves at least the following host state information:

but for guest state it says "the following"

  Loading Guest State. After saving host state, VMRUN loads the following guest
  state from the VMCB:

and then both provide incomplete lists of state.  A pedantic reading of the guest
case suggests that there's a large pile of state that *isn't* loaded, and the host
case isn't all that helpful because it's way too handwavy.
