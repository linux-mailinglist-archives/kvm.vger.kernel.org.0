Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F8A352ACA2
	for <lists+kvm@lfdr.de>; Tue, 17 May 2022 22:21:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350403AbiEQUVg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 May 2022 16:21:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352966AbiEQUVZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 May 2022 16:21:25 -0400
Received: from mail-oa1-x2f.google.com (mail-oa1-x2f.google.com [IPv6:2001:4860:4864:20::2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96AAB2EA3C
        for <kvm@vger.kernel.org>; Tue, 17 May 2022 13:21:24 -0700 (PDT)
Received: by mail-oa1-x2f.google.com with SMTP id 586e51a60fabf-f189b07f57so84657fac.1
        for <kvm@vger.kernel.org>; Tue, 17 May 2022 13:21:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=68dvhPpLwJG0pZQrjjJez++0CXbxD7JMybkjDL2dPC4=;
        b=WTn2BxK3Cy6eJbw/x/PLr0m4r+9X6fsuuQZwbDZxe248Zk66ETVqaxhCfXA2RZoTPk
         DSjIVnztwK9E5f3911JVsdfVMDANIhJ8Af+rDeoJ/G+d8D1wHtn2PEW89NYRXkbinQ+n
         Pz0Tke6Sm2tgod5sffo4v0FNFtHMCHVsZ6VQoAuPjAYxcuoaraycEZvHzr+zjzFpQXU1
         v/qMB36wEy/U0pJWpfYsAABL7K9yvc9Y+/ClJlWToIZQsxXdsboAVYqNT/KT2TyPOCmN
         uuAJV7oVX/4yc5tvWLBQdismth+wVBJcNI0UVwuep+1jE5Wa1WxS7If0MWryrjvkYBZa
         xRnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=68dvhPpLwJG0pZQrjjJez++0CXbxD7JMybkjDL2dPC4=;
        b=mXQ/GLtee+npTVx/AnewGp/AQVGThXK6I3WRPgSW2nww4rvWpQEyDKaelisw7JW3wZ
         +Z4nvJVQH2GrD1mIj335cb8p9uQMBDaTpS+EBH2gnDUPsxyaOSbJ7X3o6VdElPMmvBvY
         +5TUaoVlnZdl1bhp1zmUf5768OsgkU6tA4skDmyUmOIm6SyAjOrBMcBn7oV0IRhyoNhQ
         NCpHMIOQVfK58V5Ut9t+2yQSlTggg2xe4sfJGojX4BAARRZS9nvgKXP56Nr5fKOYHDTP
         aMSNwNi4MqChjcyAR+mUy04y7Cy09AaHTCdTX9FyMopGdipkfb3ZF4axfhh6VxLz3AbO
         8/3A==
X-Gm-Message-State: AOAM5312dNJQ65SOT6MivRZ1ir/OASgicFzDMsjytmAu/XOIeiFVIH9D
        SiwoNuL1rwsjXXvaXGwPpJprSl11GrFS2YCirV6wVw==
X-Google-Smtp-Source: ABdhPJyolRjRC0rp9jmGwKsnB3sv21OGehray1uHcDH+uAlAx25rN5xBzuoaS7p3y3IJsaXDkHrUHf31QDYyJ81fg9c=
X-Received: by 2002:a05:6870:41c4:b0:e6:6550:2da3 with SMTP id
 z4-20020a05687041c400b000e665502da3mr19958665oac.13.1652818883787; Tue, 17
 May 2022 13:21:23 -0700 (PDT)
MIME-Version: 1.0
References: <20220510224035.1792952-1-jmattson@google.com> <20220510224035.1792952-2-jmattson@google.com>
 <Ynr6Z1G3efTmt3mr@google.com>
In-Reply-To: <Ynr6Z1G3efTmt3mr@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Tue, 17 May 2022 13:21:12 -0700
Message-ID: <CALMp9eRy9RqrEu5gSndCu1L4m4pMxfxAuw+4YnnN4-BHXDOz_Q@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] KVM: VMX: Print VM-instruction error as unsigned
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

On Tue, May 10, 2022 at 4:51 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Tue, May 10, 2022, Jim Mattson wrote:
> > Change the printf format character from 'd' to 'u' for the
> > VM-instruction error in vmwrite_error().
> >
> > Fixes: 6aa8b732ca01 ("[PATCH] kvm: userspace interface")
> > Reported-by: Sean Christopherson <seanjc@google.com>
> > Signed-off-by: Jim Mattson <jmattson@google.com>
> > ---
>
> Reviewed-by: Sean Christopherson <seanjc@google.com>

Paolo?
