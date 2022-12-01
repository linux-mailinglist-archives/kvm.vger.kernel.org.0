Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EDEB63F8A3
	for <lists+kvm@lfdr.de>; Thu,  1 Dec 2022 20:56:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229890AbiLAT4P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Dec 2022 14:56:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229723AbiLAT4N (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Dec 2022 14:56:13 -0500
Received: from mail-yw1-x1132.google.com (mail-yw1-x1132.google.com [IPv6:2607:f8b0:4864:20::1132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8CD4BA602
        for <kvm@vger.kernel.org>; Thu,  1 Dec 2022 11:56:12 -0800 (PST)
Received: by mail-yw1-x1132.google.com with SMTP id 00721157ae682-3bf4ade3364so28428527b3.3
        for <kvm@vger.kernel.org>; Thu, 01 Dec 2022 11:56:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Y/EMS9l1tMDYyUwLY6kLwS4bNT4CqcTztunRoHiszYc=;
        b=Ys50Gv/tq038tblMmIdubt+UbOrYG1DD3hHOWT01FN4O/60kiCzebwzhPEm2X0BDar
         9GlnJ+ZSfpj3VETolc5+aR6sYNzYZk3Irmd8/PB1+drGxP+Sxzlv4mtUTMz9IRDCQCvk
         r3N7iCN+EQi/nvDahl8mSNm4DOimM1aU0w/rDzVFFAJh0MxcaLcd2lKCMTGKNlCigffN
         F1PaVwpzlRUZcR+zTE1UlmApG801wgMTQJvzlLPzSqHAHKu1fv92LNvXD0ozoAPs986a
         BVa8u04ukQasy/rE5eFjeO9LRlc/fGdFD5/a8eJ4zCZ7pchB7OWTm/Iew6+Y1oxz84I3
         eJjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Y/EMS9l1tMDYyUwLY6kLwS4bNT4CqcTztunRoHiszYc=;
        b=HSjDN8QfcCY/pmC90zQvDReVyPUl2rP8L03OzS7q3Gu85Cr/K1P6+gSb7GXGK+FzxL
         MbWXYJXptWD9Ldtp4YFYc0zejkA6R1ewDeaFl7pxw4ZrGmKrQYCvEWULZmCeYgN4GHrR
         lUbEEsxE4CtiqBt/cINx3tkBEI9hroVlEvbf73pN1nm/klgMb18I89L+qGVFZwbvU1kJ
         dLsNpTpPBrQjrTKrvJqEziroiALdfSaoHuNFgtclZSbjU4IwYF64qhRgsIN6jxrCTVh0
         tS9/E2HSgPDZL3OrzUEU+GoS76Y8TK03R+PE9OI+J+NCRmWDKVRJBm28x05UXD5ZIOO2
         n/uA==
X-Gm-Message-State: ANoB5pnEgeFfvoyUw3F6cjk8hQ9GCMp4M/Y0oK9B0MI9cnXqE+t12daw
        oIqL72/c9esnA/ZIOQ3PrDrq1uKsUzEPyTzXy+gVEw==
X-Google-Smtp-Source: AA0mqf6DW4Wodn09VRuCSx9flCnE1J1Pl/Klt01lTCMK7LKR/i7rnHD+Tw3YgfC7akrq4L2FXGRBpfMTkHN19yilwGY=
X-Received: by 2002:a81:6343:0:b0:36a:75b3:fdda with SMTP id
 x64-20020a816343000000b0036a75b3fddamr45489613ywb.168.1669924571807; Thu, 01
 Dec 2022 11:56:11 -0800 (PST)
MIME-Version: 1.0
References: <20221117001657.1067231-1-dmatlack@google.com> <20221117001657.1067231-4-dmatlack@google.com>
 <97ccc949-254e-879d-9206-613b328c271d@huawei.com> <CALzav=fY6-C_Y1+8B0_hQM9X8L-SA2cEULgcp24-6f_xVLgkqw@mail.gmail.com>
 <CALzav=dxO9uN63vuhdmja5s5y1PLUOA36KdCVwVWWALgCjBpSw@mail.gmail.com> <1d4c8e5a-ea56-de93-67d0-0fa47116ad4c@huawei.com>
In-Reply-To: <1d4c8e5a-ea56-de93-67d0-0fa47116ad4c@huawei.com>
From:   David Matlack <dmatlack@google.com>
Date:   Thu, 1 Dec 2022 11:55:45 -0800
Message-ID: <CALzav=fO=E0Ei8HwGeGn_Du0urtqtEWC9WLuCcGpG-F_RGE6Tw@mail.gmail.com>
Subject: Re: [RFC PATCH 3/3] KVM: Obey kvm.halt_poll_ns in VMs not using KVM_CAP_HALT_POLL
To:     "wangyanan (Y)" <wangyanan55@huawei.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jon Cargille <jcargill@google.com>,
        Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        "yuzenghui@huawei.com" <yuzenghui@huawei.com>,
        wangyuan38@huawei.com
Content-Type: text/plain; charset="UTF-8"
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

On Sun, Nov 20, 2022 at 5:42 PM wangyanan (Y) <wangyanan55@huawei.com> wrote:
>
> On 2022/11/19 9:25, David Matlack wrote:
> > On Fri, Nov 18, 2022 at 8:58 AM David Matlack <dmatlack@google.com> wrote:
> >> On Fri, Nov 18, 2022 at 12:28 AM wangyanan (Y) <wangyanan55@huawei.com> wrote:
> >>> Hi David,
> >>>
> >>> On 2022/11/17 8:16, David Matlack wrote:
> >>>> Obey kvm.halt_poll_ns in VMs not using KVM_CAP_HALT_POLL on every halt,
> >>>> rather than just sampling the module parameter when the VM is first
> >>> s/first/firstly
> >>>> created. This restore the original behavior of kvm.halt_poll_ns for VMs
> >>> s/restore/restores
> >>>> that have not opted into KVM_CAP_HALT_POLL.
> >>>>
> >>>> Notably, this change restores the ability for admins to disable or
> >>>> change the maximum halt-polling time system wide for VMs not using
> >>>> KVM_CAP_HALT_POLL.
> >>> Should we add more detailed comments about relationship
> >>> between KVM_CAP_HALT_POLL and kvm.halt_poll_ns in
> >>> Documentation/virt/kvm/api.rst? Something like:
> >>> "once KVM_CAP_HALT_POLL is used for a target VM, it will
> >>> completely ignores any future changes to kvm.halt_poll_ns..."
> >> Yes we should.
> >>
> >> I will do some testing on this series today and then resend the series
> >> as a non-RFC with the Documentation changes.
> >>
> >> Thanks for the reviews.
> > Initial testing looks good but I did not have time to finish due to a
> > bug in how our VMM is currently using KVM_CAP_HALT_POLL. I will be out
> > all next week so I'll pick this up the week after.
> OK, thanks.

I see that Linus already merged these patches into 6.1-rc7, so I've
sent the Documentation changes as a separate series.

https://lore.kernel.org/kvm/20221201195249.3369720-1-dmatlack@google.com/
