Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A7DB4F9ED0
	for <lists+kvm@lfdr.de>; Fri,  8 Apr 2022 23:10:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232824AbiDHVJ2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Apr 2022 17:09:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239739AbiDHVJT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Apr 2022 17:09:19 -0400
Received: from mail-oa1-x36.google.com (mail-oa1-x36.google.com [IPv6:2001:4860:4864:20::36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A7F014D028
        for <kvm@vger.kernel.org>; Fri,  8 Apr 2022 14:07:14 -0700 (PDT)
Received: by mail-oa1-x36.google.com with SMTP id 586e51a60fabf-deb9295679so11014437fac.6
        for <kvm@vger.kernel.org>; Fri, 08 Apr 2022 14:07:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Oc2AW4KQdbpRhUv5F+kUPvcbi8O2BIjFV/r10/0x7dc=;
        b=dzDE8jVvd8YPHBFM7A3xYMwS6L/PURPb1WjAx+ewbDxIowHBbiDGv4bmFTPQxBMJ9r
         W+VIFXAkIM14xOh8y6TPPf/oT1BilVfBs7GL027La3BQ0ezrCA0v1sQNYf3+s+NfQGrj
         GLFQ8KFl1FWTdXlpL4+adeUY1Of+zPRgrjiWZTzB3PhNmplke9oiqeFASOFbv/mXSh6l
         gyJ5bFx7GVLRS2q5YouCBY70iAii/fVkCN3/z1hD30G3rSs3621DMtkQQOwf7Y7xA2G3
         pE+epTQtfGP+7gB3Xs/QoyfEN/QqGBwRiEs1ZfYVsHWu7bjRDy2dMtxcGwVlUml0puj0
         eByg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Oc2AW4KQdbpRhUv5F+kUPvcbi8O2BIjFV/r10/0x7dc=;
        b=BiJJDb1roW0H6G/Usyhbtp/mYgHgQ5it1D5jjTyQi2QNBubebJcsglFYkuIRc/VKAz
         11WdJUOyXDvxWMbMsSKMMd3iu5AAGTr1u5t0E6eA9Br3L9f3sx6jzw6vy4wY6ol+hAct
         X2eh2EBKbPaEvWCsJyJ7XkHVYI5iAXb4/eSK6GlfSdTHx2+a5OmSpf+7xB2gRxqMBIJz
         fUMLMPIUH7oESVoTY9qymk4XmgTXqc5jSSvieL7luCZFdqsgL4lGldJG02P3JTHqzy0S
         LlZYF80SLdgo31lNgcYHFL7Z8hACc/DmEZPK2Ej05Pj31+bcK0f4iix+Sha5mk2awR59
         GDfA==
X-Gm-Message-State: AOAM531MBcUdDiF+ndSVLQCVtI1UwBEoUofZkcciuHdE5pQQerpS/3RC
        1EohWHw7q+7WJRBnKuTI5HCSkID/mrQpLOnzBMzJxoPayvtYlg==
X-Google-Smtp-Source: ABdhPJyIkz8tuxmTq9Ycn8ej07yZQekvtYE5dhbeY1ITaPNpUzZhkLBiDSKm5w3Yrae/yL0tD62AMuYmaSQlBerREV0=
X-Received: by 2002:a05:6871:79c:b0:db:5bd:8751 with SMTP id
 o28-20020a056871079c00b000db05bd8751mr9635955oap.13.1649452033586; Fri, 08
 Apr 2022 14:07:13 -0700 (PDT)
MIME-Version: 1.0
References: <20220225012959.1554168-1-jmattson@google.com> <YhgxvA4KBEZc/4VG@google.com>
 <CALMp9eTnB51PL8VUc2Do0wyJ_VqDDEoYKF_Hm_sF56x5-MxM1A@mail.gmail.com>
In-Reply-To: <CALMp9eTnB51PL8VUc2Do0wyJ_VqDDEoYKF_Hm_sF56x5-MxM1A@mail.gmail.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Fri, 8 Apr 2022 14:07:02 -0700
Message-ID: <CALMp9eQ9BQvuBZMYntz+-4c7xYcANSe37T-O0+v_uwMDdpAiOw@mail.gmail.com>
Subject: Re: [PATCH] KVM: VMX: Fix header file dependency of asm/vmx.h
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com
Content-Type: text/plain; charset="UTF-8"
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

On Thu, Feb 24, 2022 at 5:34 PM Jim Mattson <jmattson@google.com> wrote:
>
> On Thu, Feb 24, 2022 at 5:32 PM Sean Christopherson <seanjc@google.com> wrote:
>
> > Paolo, any chance you want to put these in alphabetical order when applying? :-)
>
> Alphabetical?!? Not reverse fir tree?

Any order is fine with me, actually.
