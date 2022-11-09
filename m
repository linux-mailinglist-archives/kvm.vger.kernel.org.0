Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BC7062330A
	for <lists+kvm@lfdr.de>; Wed,  9 Nov 2022 19:54:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230182AbiKISx7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Nov 2022 13:53:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231611AbiKISxd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Nov 2022 13:53:33 -0500
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03C2BDBA
        for <kvm@vger.kernel.org>; Wed,  9 Nov 2022 10:53:22 -0800 (PST)
Received: by mail-wm1-x334.google.com with SMTP id 187-20020a1c02c4000000b003cf9c3f3b80so1930585wmc.0
        for <kvm@vger.kernel.org>; Wed, 09 Nov 2022 10:53:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=kdPqoyAycB6pgUJuMzMPu8rx+xZgOcOan+fWmuoVt8A=;
        b=AT43cV5BI+6lOtWe0fLdN0byEHao02SLceBCCuNbrsxSssZWdgMdHV8XbgvlzfqJ8s
         j9ZmOm+3/vuslwAjMlVzki06YltbNwu8aOogTCaXpoNbXnzFpcL/dX4qsn06wlw/tQm5
         KShnH1VRFvNjylcK31wwpwBYeq+Ax8def+OSMXPjECSFQ93Q2ZQe6onSL5wyAhEbYQa1
         RxpNA+XN0al7dJ0yBIKLF4sLGPOC2n988MyUA+XLdJyMW9ffz6ERxW1f3G+co2ozjJa0
         lMS6pj+H3YI1lqDrjp+8pWotGpefCP1orFMn9qFvhYV9Mr9cmI7LGWp6jtF3WOL4tt6X
         6hyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kdPqoyAycB6pgUJuMzMPu8rx+xZgOcOan+fWmuoVt8A=;
        b=IbJwFDn38l0EqYQdUSWEeiddCSulSS/LQ+vpFtkNhd0Q+NqC0nVn8nUUmZ48XsvlDv
         OX/ae5B5BBWvjov5GR/BLL38BxcloEDRSepkn4bZbyubiqleMbUJP/l80bLS6yjDIG7d
         IpIhkUuWeXNgBcMFb3dOZqQjoHnoYADVQf+gQIgNGSJ5g1pfz1gu1KkuHPsbS3MgBndu
         BVjWBONbjdCqe7ioPa8UHrA6oGxU5FLGM72pcZGwOnW+AH2nqqZeE5EAsYFTQ5M/1vd0
         e0AA8XvQtkEeRwQYAq8NJB9omBq7p4jPpFGroGyBfZ0OQBzVrCJE0BrhTow9e/nBhGAx
         yFmw==
X-Gm-Message-State: ANoB5plG9r1n3v/iwfkJD84ev/t0TxhiINb9MvD+teVovXuBRZKQTGQv
        HHSHeQoWpgnaqHbF9NtNOnwpw4KPMBMqbuyy5fAo9Q==
X-Google-Smtp-Source: AA0mqf434Gt0mmlTBVl9f0K312YzqHufnNREe5hC1WhXil1S+ZC/776mJtyhLZGis6/nxbafTGi34A+JlFz9vGQdHm4=
X-Received: by 2002:a7b:ce09:0:b0:3cf:ba0d:6553 with SMTP id
 m9-20020a7bce09000000b003cfba0d6553mr6407971wmc.112.1668020001136; Wed, 09
 Nov 2022 10:53:21 -0800 (PST)
MIME-Version: 1.0
References: <20221105045704.2315186-1-vipinsh@google.com> <20221105045704.2315186-5-vipinsh@google.com>
 <874jv8p7c5.fsf@ovpn-194-83.brq.redhat.com>
In-Reply-To: <874jv8p7c5.fsf@ovpn-194-83.brq.redhat.com>
From:   Vipin Sharma <vipinsh@google.com>
Date:   Wed, 9 Nov 2022 10:52:45 -0800
Message-ID: <CAHVum0eYbQJvXY_TVyjadAYVrAcwXSEyJhpddkcBSohj+i+LqA@mail.gmail.com>
Subject: Re: [PATCH 4/6] KVM: selftests: Make Hyper-V guest OS ID common
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, seanjc@google.com,
        pbonzini@redhat.com
Cc:     dmatlack@google.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 9, 2022 at 5:48 AM Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
>
> Vipin Sharma <vipinsh@google.com> writes:
>
> > Make guest OS ID calculation common to all hyperv tests and similar to
> > hv_generate_guest_id().
>
> A similar (but without hv_linux_guest_id()) patch is present in my
> Hyper-V TLB flush update:
>
> https://lore.kernel.org/kvm/20221101145426.251680-32-vkuznets@redhat.com/
>

After getting feedback from David, I decided to remove
LINUX_VERSION_CODE in v2. Our patches are functionally identical now.

@Sean, Paolo, Vitaly
Should I be rebasing my v2 on top of TLB flush patch series and remove
patch 4 and 5 from my series? I am not sure how these situations are
handled.

@Vitaly
Are you planning to send v14?

If yes, then for v13 Patch 31 (KVM: selftests: Move HYPERV_LINUX_OS_ID
definition to a common header) will you keep it same or will you
modify it to add  HYPERV_LINUX_OS_ID  in hyperv_clock.c and
hyperv_svm_test.c?

If not, then I can add a patch in my series to change those two files
if I end up rebasing on top of your series.
