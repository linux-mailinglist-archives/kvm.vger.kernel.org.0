Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B766128EBB6
	for <lists+kvm@lfdr.de>; Thu, 15 Oct 2020 05:45:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729312AbgJODpZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Oct 2020 23:45:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727281AbgJODpZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Oct 2020 23:45:25 -0400
Received: from mail-lf1-x142.google.com (mail-lf1-x142.google.com [IPv6:2a00:1450:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7744C061755
        for <kvm@vger.kernel.org>; Wed, 14 Oct 2020 20:45:23 -0700 (PDT)
Received: by mail-lf1-x142.google.com with SMTP id b1so1840046lfp.11
        for <kvm@vger.kernel.org>; Wed, 14 Oct 2020 20:45:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=z9zMX2coYN8H3CBILNpr7q+Vk2fAdNTcRYoWO7ULwRE=;
        b=kKMdDH+imlskdTjp+gjVXY1DrKt1Ep3Ytjb9qBpCPjUyBhxbCRiecmIslucxehpO4n
         94K6JKqf4UWSCahN3lwioeQ1xls6OR+ilsIPeQej9Otm8Zr6MrYAxTtSJwp0K6pzKYHU
         L2y1CMmLkLgDHlFIA/AZ9NpRnJW6tranwh6+AYlOSR2COC8/lGkWHPJJM8q7TPU7HfmW
         Pj+YaAK3TdiMtE7RrMsMD2MK0zu/h9FdyrISKIc7dH1knGMCNQVCCQu5+WskQsLcUxG/
         /uAveQssjFvYZ2PW7294kGGKD89Mnw7fMO2Sgym2cJk8lQWa3ZcpqsVTe5NmNkbWpgWE
         k1MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=z9zMX2coYN8H3CBILNpr7q+Vk2fAdNTcRYoWO7ULwRE=;
        b=bKyxEKdzTjugoJDR1DdOm0+hCwnR5/Q4peHnxwuIDkg9Izjh0saZlak0ZD+BJOifEQ
         BjXEOawNZpwCHfDOOWXWYf65YIBa3dKUnESG46w5sjaNUqQHPWc1vwmp5TmqGJzRYBpz
         VcxOgAz82FMAv7o1HldqxriJMSpjrDm7Kd2a08btpJGjc5SLTapc/0i0i1kHEjovwAHS
         Tme9Dglf3l1PfEyveX32/wCFJkdt460Vm2EpJyyANvvdlMj3E/ei1XApZI1XRJl4Lnzd
         B9MqyW2ApKzUE4I6B/aGE/dbOmMkS229iluRwz9DW/U7cffdb/SGC9yhcmbCZSNVf5HX
         YcLA==
X-Gm-Message-State: AOAM533uqCZreFwYUPT4j2ELwhQj1n2om9mh4zIvP8RuH1xnwR+QpO2W
        cUqzCO/sJXmxaOAweHa5et4MbzWeQ7zPIcusnjU=
X-Google-Smtp-Source: ABdhPJxmhGw0f35E0C3XKDWPhs9gxr7BD5N3ErbxT6FYWhPozjavL7xvKRkSdQMsQ7Mb2VXX/bDxA/I2LFN3YqzxYxM=
X-Received: by 2002:a19:4bd4:: with SMTP id y203mr330362lfa.539.1602733522366;
 Wed, 14 Oct 2020 20:45:22 -0700 (PDT)
MIME-Version: 1.0
References: <CA+-xGqMd4_58_+QKetjOsubBqrDnaYF+YWE3TC3kEcNGxPiPfg@mail.gmail.com>
 <47ead258320536d00f9f32891da3810040875aff.camel@redhat.com>
 <CA+-xGqOm2sWbxR=3W1pWrZNLOt7EE5qiNWxMz=9=gmga15vD2w@mail.gmail.com>
 <20201012165428.GD26135@linux.intel.com> <CA+-xGqPkkiws0bxrzud_qKs3ZmKN9=AfN=JGephfGc+2rn6ybw@mail.gmail.com>
 <20201013045245.GA11344@linux.intel.com> <CA+-xGqO4DtUs3-jH+QMPEze2GrXwtNX0z=vVUVak5HOpPKaDxQ@mail.gmail.com>
 <CA+-xGqMMa-DB1SND5MRugusDafjNA9CVw-=OBK7q=CK1impmTQ@mail.gmail.com>
 <a163c2d8-d8a1-dc03-6230-a2e104e3b039@redhat.com> <CA+-xGqOMKRh+_5vYXeLOiGnTMw4L_gUccqdQ+HGSOzuTosp6tw@mail.gmail.com>
 <a4f3816dab09f4e28e33c66b8ff8273147415567.camel@redhat.com>
In-Reply-To: <a4f3816dab09f4e28e33c66b8ff8273147415567.camel@redhat.com>
From:   harry harry <hiharryharryharry@gmail.com>
Date:   Wed, 14 Oct 2020 23:45:02 -0400
Message-ID: <CA+-xGqME1C180HcEfOF2cxUtmH6ZeeGqbGYjfYrE7ke8DpuzUg@mail.gmail.com>
Subject: Re: Why guest physical addresses are not the same as the
 corresponding host virtual addresses in QEMU/KVM? Thanks!
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        qemu-devel@nongnu.org, mathieu.tarral@protonmail.com,
        stefanha@redhat.com, libvir-list@redhat.com, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Maxim,

Thanks for your emphasis. It's much clearer.

Best,
Harry
