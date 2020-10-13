Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2624A28D56E
	for <lists+kvm@lfdr.de>; Tue, 13 Oct 2020 22:36:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726186AbgJMUgp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Oct 2020 16:36:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725977AbgJMUgp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Oct 2020 16:36:45 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F28A5C061755
        for <kvm@vger.kernel.org>; Tue, 13 Oct 2020 13:36:44 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id l2so1249299lfk.0
        for <kvm@vger.kernel.org>; Tue, 13 Oct 2020 13:36:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NQjQ2k5Saht+0v/Nw1gJ06v1KosSim39Rrh/K70mE9E=;
        b=jQaesPSFTPRhdaJ/IqEXZZ70+scGkNb1HDPfK0KW1sqhP4cGHHqrqbj3R4XFat/hI6
         kNzBtGPjo6gxc1fjnQPZzYfA351zCCY7KaRTj5adeqKSIUy55WSUP+UCmmBGd3DnVuTu
         hPBFcJENBJ6F49GIFfi8K8XoSuq0AptuOLd2jROZc9v9vK4o/ETSzfbBEWqQz237jgpk
         pA5GJyuGgTJaVa8EfxDL3DW91H+9zpBHVIFimRxOufQQu4ehrba7mwhg89+F42mUL2E6
         SBmQLmz6PmQTa8LeUIMG5GalZy1R93WKzOHMUNFJHD1FnvYbIa3Yomn9KqLZAKE/nAKt
         mfDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NQjQ2k5Saht+0v/Nw1gJ06v1KosSim39Rrh/K70mE9E=;
        b=nU/c+C5H9mfllzuCtN/d9WgpX6IGj5I3Op0ARbuE1bq4E8rhStlPA25ElDMo2t55Wp
         yFMaCIlumSNFoOzOOWZH5bx7ihhhR+JndFJTZ187Xl0qq1oj9GdJbm6UaXi0S4eodrJi
         n5QZtVpWQqUzgK0a3LLHfwQnD2RuNhDiIqLP6TWa2uaocOMDXn/d/2q5Gh2O1ye7C25F
         aC4lPgfMUuCQ3k72Crv4lhWVTTr5kK9+nlRyt/TJp9dUeTbHu/vuXUaT62X8YkUanaiY
         7UMC/Gz703zigLanEu0IdOZue0ATadwF6artVWttooaN5+ucLh4IozjPK0epWxbElmAL
         aAjA==
X-Gm-Message-State: AOAM531IRZ1jK3cGcLEA0etLYVR+P96EgidACIWNO0U1iS97MYlM/4mR
        K4pRz3n1DLAmT1yr/Uyw7/nx0zDs26dG8kxiEAn4ogpNIDk=
X-Google-Smtp-Source: ABdhPJyc4gYiGMgm7ccRbPjdTl523pIjBDmx0/crijD7nRyGalWIpfyK/BHYXHE1SSV/b2RI2rJ28LKu9QHjo9pCIdc=
X-Received: by 2002:a19:8256:: with SMTP id e83mr332082lfd.530.1602621403376;
 Tue, 13 Oct 2020 13:36:43 -0700 (PDT)
MIME-Version: 1.0
References: <CA+-xGqMd4_58_+QKetjOsubBqrDnaYF+YWE3TC3kEcNGxPiPfg@mail.gmail.com>
 <47ead258320536d00f9f32891da3810040875aff.camel@redhat.com>
 <CA+-xGqOm2sWbxR=3W1pWrZNLOt7EE5qiNWxMz=9=gmga15vD2w@mail.gmail.com>
 <20201012165428.GD26135@linux.intel.com> <CA+-xGqPkkiws0bxrzud_qKs3ZmKN9=AfN=JGephfGc+2rn6ybw@mail.gmail.com>
 <20201013045245.GA11344@linux.intel.com> <CA+-xGqO4DtUs3-jH+QMPEze2GrXwtNX0z=vVUVak5HOpPKaDxQ@mail.gmail.com>
 <CA+-xGqMMa-DB1SND5MRugusDafjNA9CVw-=OBK7q=CK1impmTQ@mail.gmail.com> <a163c2d8-d8a1-dc03-6230-a2e104e3b039@redhat.com>
In-Reply-To: <a163c2d8-d8a1-dc03-6230-a2e104e3b039@redhat.com>
From:   harry harry <hiharryharryharry@gmail.com>
Date:   Tue, 13 Oct 2020 16:36:25 -0400
Message-ID: <CA+-xGqOMKRh+_5vYXeLOiGnTMw4L_gUccqdQ+HGSOzuTosp6tw@mail.gmail.com>
Subject: Re: Why guest physical addresses are not the same as the
 corresponding host virtual addresses in QEMU/KVM? Thanks!
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Maxim Levitsky <mlevitsk@redhat.com>, qemu-devel@nongnu.org,
        mathieu.tarral@protonmail.com, stefanha@redhat.com,
        libvir-list@redhat.com, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Paolo and Sean,

Thanks much for your prompt replies and clear explanations.

On Tue, Oct 13, 2020 at 2:43 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> No, the logic to find the HPA with a given HVA is the same as the
> hardware logic to translate HVA -> HPA.  That is it uses the host
> "regular" page tables, not the nested page tables.
>
> In order to translate GPA to HPA, instead, KVM does not use the nested
> page tables.

I am curious why KVM does not directly use GPAs as HVAs and leverage
nested page tables to translate HVAs (i.e., GPAs) to HPAs? Is that
because 1) the hardware logic of ``GPA -> [extended/nested page
tables] -> HPA[*]'' is different[**] from the hardware logic of ``HVA
-> [host regular page tables] -> HPA''; 2) if 1) is true, it is
natural to reuse Linux's original functionality to translate HVAs to
HPAs through regular page tables.

[*]: Here, the translation means the last step for MMU to translate a
GVA's corresponding GPA to an HPA through the extended/nested page
tables.
[**]: To my knowledge, the hardware logic of ``GPA -> [extended/nested
page tables] -> HPA'' seems to be the same as the hardware logic of
``HVA -> [host regular page tables] -> HPA''. I appreciate it if you
could point out the differences I ignored. Thanks!

Best,
Harry
