Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5DFE6EDB44
	for <lists+kvm@lfdr.de>; Tue, 25 Apr 2023 07:42:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233306AbjDYFm5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Apr 2023 01:42:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231351AbjDYFm4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Apr 2023 01:42:56 -0400
Received: from mail-qt1-x835.google.com (mail-qt1-x835.google.com [IPv6:2607:f8b0:4864:20::835])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 310D97AA8
        for <kvm@vger.kernel.org>; Mon, 24 Apr 2023 22:42:51 -0700 (PDT)
Received: by mail-qt1-x835.google.com with SMTP id d75a77b69052e-3ef6e8493ebso11328281cf.2
        for <kvm@vger.kernel.org>; Mon, 24 Apr 2023 22:42:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682401370; x=1684993370;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZqOIjUQas8Rx1/5sAHd8nDe5JfxJxpYrGJ2aW1S7/QE=;
        b=FBq0wSQZHFhDmAXJRtxc/cteLPhGBUqYaKY4zqT63wqEVsVXk7rqp7CpgtfyIu6gSD
         udOyk8v0wGFB+CVpkRCnnPbGB2GvhQIQHDFAsUpiRagIFEXWAyK3EmDIBnYTVqnWm1o2
         GMQM78qvzSLYO4EdyjzmOI8lt7uEchuf6nrzBzZLjts+CfO3cHrpQCe3tKIxoHzUve9f
         NYQHVsjLsloE70BlqCuNtEWnDdhl+iDhyaLrtFOFbYu2a1UFWPKzIyCL3uKRFq59lxF1
         Mf6m6iiXNgXeFroxFVzWN+Q73d5hXPMX/csrrsJeBTEI5TFc+82Y1DNF21hM2ls92zAh
         cgjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682401370; x=1684993370;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZqOIjUQas8Rx1/5sAHd8nDe5JfxJxpYrGJ2aW1S7/QE=;
        b=RJ1LVC7CFVmOvM9ubd2dp6CbRVfdyTNn8SCIj3VPxJCqVlGhPhlLwGebUbohQOGRLK
         s/RINZRUfjWJkEgDwkRC1QRRnaIuhEy67xwafXuICLPNy4FFFTVTnckczbqOAeJgPCjZ
         a2P7H5Ijwi50eisRaZLMknlVubVbpDZD9m6QYCXViNsHJd5Dlrzb0Z+9AWM5+YBA57SO
         +nIAEqPPVKJ0JjOGdEPNqQvMCHt/I/J7lB9IVHWe7PSc+vGGTVPiSSZuAikM5K5fRfo+
         HcCQ2DdxmkHgctf25jjfVIZ9haxbyKzOX9/QLTw+3DYkjhOK3RYcdcIJ2zuQIjbdAkQJ
         kOcw==
X-Gm-Message-State: AAQBX9dWWCblUMO08C+EiWRVoZwtD8c2od1QLXp3zi+Ma0G5KpJjzzTH
        CCcfUDedOZUqbk0UFVO6eZelC5DF5//1VsBhbDkYdlZKGUq5lA==
X-Google-Smtp-Source: AKy350YNhM9vliZvFdaghRH04BWbcCfd9ESSD8DXYLJEnsZ7/gtC/Wrot6ju3hxldLyczOrK6tmEF0ll4WNq9TVV65w=
X-Received: by 2002:ac8:5c8c:0:b0:3d7:960e:5387 with SMTP id
 r12-20020ac85c8c000000b003d7960e5387mr23905537qta.35.1682401370265; Mon, 24
 Apr 2023 22:42:50 -0700 (PDT)
MIME-Version: 1.0
References: <20230424163401.23018-1-babu.moger@amd.com> <20230424163401.23018-2-babu.moger@amd.com>
In-Reply-To: <20230424163401.23018-2-babu.moger@amd.com>
From:   Robert Hoo <robert.hoo.linux@gmail.com>
Date:   Tue, 25 Apr 2023 13:42:39 +0800
Message-ID: <CA+wubQCGyXujRJvREaWX97KhT0sw8o9bf_+qa6C0gYkcbrqr9A@mail.gmail.com>
Subject: Re: [PATCH v3 1/7] target/i386: allow versioned CPUs to specify new cache_info
To:     Babu Moger <babu.moger@amd.com>
Cc:     pbonzini@redhat.com, richard.henderson@linaro.org,
        weijiang.yang@intel.com, philmd@linaro.org, dwmw@amazon.co.uk,
        paul@xen.org, joao.m.martins@oracle.com, qemu-devel@nongnu.org,
        mtosatti@redhat.com, kvm@vger.kernel.org, mst@redhat.com,
        marcel.apfelbaum@gmail.com, yang.zhong@intel.com,
        jing2.liu@intel.com, vkuznets@redhat.com, michael.roth@amd.com,
        wei.huang2@amd.com, berrange@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Babu Moger <babu.moger@amd.com> =E4=BA=8E2023=E5=B9=B44=E6=9C=8825=E6=97=A5=
=E5=91=A8=E4=BA=8C 00:42=E5=86=99=E9=81=93=EF=BC=9A
>
> From: Michael Roth <michael.roth@amd.com>
>
> New EPYC CPUs versions require small changes to their cache_info's.

Do you mean, for the real HW of EPYC CPU, each given model, e.g. Rome,
has HW version updates periodically?

> Because current QEMU x86 CPU definition does not support cache
> versions,

cache version --> versioned cache info

> we would have to declare a new CPU type for each such case.

My understanding was, for new HW CPU model, we should define a new
vCPU model mapping it. But if answer to my above question is yes, i.e.
new HW version of same CPU model, looks like it makes sense to some
extent.

> To avoid this duplication, the patch allows new cache_info pointers
> to be specified for a new CPU version.

"To avoid the dup work, the patch adds "cache_info" in X86CPUVersionDefinit=
ion"
>
> Co-developed-by: Wei Huang <wei.huang2@amd.com>
> Signed-off-by: Wei Huang <wei.huang2@amd.com>
> Signed-off-by: Michael Roth <michael.roth@amd.com>
> Signed-off-by: Babu Moger <babu.moger@amd.com>
> Acked-by: Michael S. Tsirkin <mst@redhat.com>
> ---
>  target/i386/cpu.c | 36 +++++++++++++++++++++++++++++++++---
>  1 file changed, 33 insertions(+), 3 deletions(-)
>
> diff --git a/target/i386/cpu.c b/target/i386/cpu.c
> index 6576287e5b..e3d9eaa307 100644
> --- a/target/i386/cpu.c
> +++ b/target/i386/cpu.c
> @@ -1598,6 +1598,7 @@ typedef struct X86CPUVersionDefinition {
>      const char *alias;
>      const char *note;
>      PropValue *props;
> +    const CPUCaches *const cache_info;
>  } X86CPUVersionDefinition;
>
>  /* Base definition for a CPU model */
> @@ -5192,6 +5193,32 @@ static void x86_cpu_apply_version_props(X86CPU *cp=
u, X86CPUModel *model)
>      assert(vdef->version =3D=3D version);
>  }
>
> +/* Apply properties for the CPU model version specified in model */

I don't think this comment matches below function.

> +static const CPUCaches *x86_cpu_get_version_cache_info(X86CPU *cpu,
> +                                                       X86CPUModel *mode=
l)

Will "version" --> "versioned" be better?

> +{
> +    const X86CPUVersionDefinition *vdef;
> +    X86CPUVersion version =3D x86_cpu_model_resolve_version(model);
> +    const CPUCaches *cache_info =3D model->cpudef->cache_info;
> +
> +    if (version =3D=3D CPU_VERSION_LEGACY) {
> +        return cache_info;
> +    }
> +
> +    for (vdef =3D x86_cpu_def_get_versions(model->cpudef); vdef->version=
; vdef++) {
> +        if (vdef->cache_info) {
> +            cache_info =3D vdef->cache_info;
> +        }

No need to assign "cache_info" when traverse the vdef list, but in
below version matching block, do the assignment. Or, do you mean to
have last valid cache info (during the traverse) returned? e.g. v2 has
valid cache info, but v3 doesn't.
> +
> +        if (vdef->version =3D=3D version) {
> +            break;
> +        }
> +    }
> +
> +    assert(vdef->version =3D=3D version);
> +    return cache_info;
> +}
> +
