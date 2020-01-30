Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF47B14DDA8
	for <lists+kvm@lfdr.de>; Thu, 30 Jan 2020 16:18:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727345AbgA3PSR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jan 2020 10:18:17 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:45937 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727241AbgA3PSQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jan 2020 10:18:16 -0500
Received: by mail-pl1-f196.google.com with SMTP id b22so1453080pls.12
        for <kvm@vger.kernel.org>; Thu, 30 Jan 2020 07:18:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20150623.gappssmtp.com; s=20150623;
        h=content-transfer-encoding:from:mime-version:subject:date:message-id
         :references:cc:in-reply-to:to;
        bh=NYvbh0EvDO+JJUvHI1Kw+aCj5n6f6RUisMfv+jrEqPU=;
        b=WabDaQ+i0RWv0Cv6UvHJUcz0N1WP3aMfcbUfawCRo720OvcWhiTwJ1iVBH8k5ZcLWG
         eSzvtnXN/BqZfpwZqxKXCFlDRK8BZLClNies16bvwsrJypJ5oNX1AIyBZJWzALHLeLfd
         6Sl8NYgZjlUBvSBzdjjXoFrCKqvByMgT+dhZGAfVEX8bSlZsFIiO5VxOmN7gFFRujZ/B
         3znM/7sck+3nTrm8vcuIQCeGZqnGRKfbkHajiQXkYquAMFLbdNvLsQqrF0/qGLV0WMQF
         CTdaAJXRegwy9gIPcl4BuI1W2PmEd5oTNb5Aqi4848b4H3S5lh8SuInCe1vJRd/x+tk7
         MxkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:content-transfer-encoding:from:mime-version
         :subject:date:message-id:references:cc:in-reply-to:to;
        bh=NYvbh0EvDO+JJUvHI1Kw+aCj5n6f6RUisMfv+jrEqPU=;
        b=Y/Ys5x4/61r3OGhgAOACXevOPXmLQ7MOjJv8gMD/jwMIPYBCnlMn5OidD3qdvqFk7r
         P4bcNZjG/XPk1MnEpfaWFzYZgdmSXpwvaqYSVMWBYQ3OKMBQx2+IXy0xsEZkkRpZDRgN
         WJvv642C/xiXPTioH6471F8UBSoMzzyNpjPW96kBjRwp5/ZEBawhpsmNwb5XEqYX0mIH
         YKwjEonQIX/GF3cs3dWAATDcGm3RIaFTYyd+BqWwqYAQcT+JwOl3N0oJKM9YMaSzx4Fa
         +Pq6CZiH1oNgWiR7vYQ9CAiVCtBLI037/KIM6uvdXF2gXRymDILCy46S4nGngsVUiBPg
         QKIg==
X-Gm-Message-State: APjAAAXYGvPXA8/pz+NTe5mCqzW3o5W5vzQ9baLXZSHEle497zFQ63t/
        mljLQPz7h9JR6neVoSDl7kq8Sw==
X-Google-Smtp-Source: APXvYqwM4KOS49ZarWpzY/mrMVV4MHQ6JjLFrmtp7HWEy4h2Xd9QI7sqRr5iXYHMNSL4zzjGZEtk0g==
X-Received: by 2002:a17:902:9a8c:: with SMTP id w12mr5176857plp.149.1580397496102;
        Thu, 30 Jan 2020 07:18:16 -0800 (PST)
Received: from ?IPv6:2601:646:c200:1ef2:51ac:4d36:2f8d:8208? ([2601:646:c200:1ef2:51ac:4d36:2f8d:8208])
        by smtp.gmail.com with ESMTPSA id d22sm6733429pgg.52.2020.01.30.07.18.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Jan 2020 07:18:15 -0800 (PST)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From:   Andy Lutomirski <luto@amacapital.net>
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH 2/2] KVM: VMX: Extend VMX's #AC handding
Date:   Thu, 30 Jan 2020 07:18:14 -0800
Message-Id: <4A8E14B3-1914-4D0C-A43A-234717179408@amacapital.net>
References: <20200130121939.22383-3-xiaoyao.li@intel.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
In-Reply-To: <20200130121939.22383-3-xiaoyao.li@intel.com>
To:     Xiaoyao Li <xiaoyao.li@intel.com>
X-Mailer: iPhone Mail (17C54)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On Jan 30, 2020, at 4:24 AM, Xiaoyao Li <xiaoyao.li@intel.com> wrote:
>=20
> =EF=BB=BFThere are two types of #AC can be generated in Intel CPUs:
> 1. legacy alignment check #AC;
> 2. split lock #AC;
>=20
> Legacy alignment check #AC can be injected to guest if guest has enabled
> alignemnet check.
>=20
> When host enables split lock detection, i.e., split_lock_detect!=3Doff,
> guest will receive an unexpected #AC when there is a split_lock happens in=

> guest since KVM doesn't virtualize this feature to guest.
>=20
> Since the old guests lack split_lock #AC handler and may have split lock
> buges. To make guest survive from split lock, applying the similar policy
> as host's split lock detect configuration:
> - host split lock detect is sld_warn:
>   warning the split lock happened in guest, and disabling split lock
>   detect around VM-enter;
> - host split lock detect is sld_fatal:
>   forwarding #AC to userspace. (Usually userspace dump the #AC
>   exception and kill the guest).

A correct userspace implementation should, with a modern guest kernel, forwa=
rd the exception. Otherwise you=E2=80=99re introducing a DoS into the guest i=
f the guest kernel is fine but guest userspace is buggy.

What=E2=80=99s the intended behavior here?=
