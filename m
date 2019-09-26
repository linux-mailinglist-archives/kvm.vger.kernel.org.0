Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD269BF29E
	for <lists+kvm@lfdr.de>; Thu, 26 Sep 2019 14:12:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726055AbfIZMMk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Sep 2019 08:12:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49328 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725815AbfIZMMk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Sep 2019 08:12:40 -0400
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com [209.85.128.70])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 699848BE70
        for <kvm@vger.kernel.org>; Thu, 26 Sep 2019 12:12:39 +0000 (UTC)
Received: by mail-wm1-f70.google.com with SMTP id o8so1086237wmc.2
        for <kvm@vger.kernel.org>; Thu, 26 Sep 2019 05:12:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=wN9I+pQTOykWj2CrD7IK9V1z8ICLlfPqN2VP1BP9wIY=;
        b=jDagjOPH0YGQEtZI7aW6zHvRIdF5SevWqD8eFm5uv9+rtXo5cI9fJ1uxy8NQzhXpdl
         2SvaeZ/dWPKUTBRo7r6Gaj93AdvcxQN3FcqnxMJqLdDP3mL/J6Q/Pi6JdwrEvE375bKz
         yusjtJle86C0OKFjkufpcamtnQQ1jwFae1e7RKN2Rl56Q9scsZoRxLScSoDGSIeuywVs
         OtWPAAwhmNDkKtJNZF+DTbWUxUBaBRzEFy5MOBy1BSoDFhCQOslEebAEF9LOhOna1P8d
         JLper6L2gCGcm8rsiwLZ/Y/J/wUkuW/CJ0FBgBu/N83xfc3A6WlIh3t746iRjtiuHapp
         LYQA==
X-Gm-Message-State: APjAAAUYExh54F9XHg6Gf/AlmaaRRxkPNIiVjQcBh1CqVFcEXdnYRMkj
        aaVkG3khdApmkKVjfWYUWr1gpwqWuGOw0soMOw61gP1qTvTTbT+MyxZy6nuscjw3H0zEGNUJ/oV
        1H2D6hiVLn1gV
X-Received: by 2002:adf:f790:: with SMTP id q16mr2649427wrp.164.1569499957911;
        Thu, 26 Sep 2019 05:12:37 -0700 (PDT)
X-Google-Smtp-Source: APXvYqy8j93qOeT9kouAyo+bvdFtag/p+jF4N3iabs8WR/gC642ne//Z6Besjyuwo9T0IgNq8roODg==
X-Received: by 2002:adf:f790:: with SMTP id q16mr2649412wrp.164.1569499957694;
        Thu, 26 Sep 2019 05:12:37 -0700 (PDT)
Received: from dritchie.redhat.com (139.red-95-120-215.dynamicip.rima-tde.net. [95.120.215.139])
        by smtp.gmail.com with ESMTPSA id y13sm7051284wrg.8.2019.09.26.05.12.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Sep 2019 05:12:36 -0700 (PDT)
References: <20190924124433.96810-1-slp@redhat.com> <20190924124433.96810-8-slp@redhat.com> <23a6e891-c3ba-3991-d627-433eb1fe156d@redhat.com> <87a7ass9ho.fsf@redhat.com> <d70d3812-fd84-b248-7965-cae15704e785@redhat.com> <87o8z737am.fsf@redhat.com> <92575de9-da44-cac4-5b3d-6b07a7a8ea34@redhat.com> <87k19v2whk.fsf@redhat.com> <b02ada95-9853-ff21-cc14-ca0acf48782a@redhat.com>
User-agent: mu4e 1.2.0; emacs 26.2
From:   Sergio Lopez <slp@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     qemu-devel@nongnu.org, mst@redhat.com, imammedo@redhat.com,
        marcel.apfelbaum@gmail.com, rth@twiddle.net, ehabkost@redhat.com,
        philmd@redhat.com, lersek@redhat.com, kraxel@redhat.com,
        mtosatti@redhat.com, kvm@vger.kernel.org
Subject: Re: [PATCH v4 7/8] docs/microvm.txt: document the new microvm machine type
In-reply-to: <b02ada95-9853-ff21-cc14-ca0acf48782a@redhat.com>
Date:   Thu, 26 Sep 2019 14:12:24 +0200
Message-ID: <87impf2r4n.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--=-=-=
Content-Type: text/plain


Paolo Bonzini <pbonzini@redhat.com> writes:

> On 26/09/19 12:16, Sergio Lopez wrote:
>>> If KVM is in use, the
>>> LAPIC timer frequency is known to be 1 GHz.
>>>
>>> arch/x86/kernel/kvm.c can just set
>>>
>>> 	lapic_timer_period = 1000000000 / HZ;
>>>
>>> and that should disabled LAPIC calibration if TSC deadline is absent.
>> Given that they can only be omitted when an specific set of conditions
>> is met, I think I'm going to make them optional but enabled by default.
>
> Please do introduce the infrastructure to make them OnOffAuto, and for
> now make Auto the same as On.  We have time to review that since microvm
> is not versioned.

OK, sounds like a good idea to me.

Thanks,
Sergio.

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEvtX891EthoCRQuii9GknjS8MAjUFAl2MqygACgkQ9GknjS8M
AjX7gBAAuIOhcJCSJRb3fNUsv+ppkFbFvve9QMXGpPDOPxNoUi4xqFkUXgTagi8y
sIBrbXsFjS0Aj/12Cle8xEuTASy0eSwCrGP1r030YhatqkDNrEhAlyRL6pmj6C2P
cibVfVQGmdd2CYwibnLuaOY4fQIfVZICbBAPHAPQT+dO6i7z1hN2RmhhsHs5qn2k
/YL87sTRx3oNC7Qzu5kwMcVLZeKtVKdQEYGcAGxD6++zH5tgz3luzTZyPODPk/Iy
ZIsqiC211A6jAld63V3bPad0Xv1LNV2HUh1rz+7KXTUMMtR+Awjq5XGg5CY7ri0i
vJ1kleICMA/Ap4eXrEdJ2CxyCFcanWejNaPnRphdqd2oxOvDnusDwRYBTnEWlCw4
6TQ3mcxRS29SVpSGmAVSnZqKb3NQ8xVrJkwhNjVxpTe+jZOwR+EnboJ3An91AhZ4
UaYbTa3gL9ihgkMiC1oYwkC8DHGnGC/0zJHkMeOvKBnLwa0U4aJPJ1jMJ8fQilqR
aS5utqGbNq4ynlipKoAthhOBk6rIR+n1GMBWiUEK/InC4GMGcdAbYsK6hW07tQMZ
ZEwwaz8cLOtUMeZVmJT0SvYeK7NRl9BjEndIf4XPD2iYFVWYLWa1p4x4a2V67x8W
eO+Q6H5KnKqKKAwpyiskPSGnIrgjnVjhVwS/JjxesUE6Dg7UTJA=
=5cKk
-----END PGP SIGNATURE-----
--=-=-=--
