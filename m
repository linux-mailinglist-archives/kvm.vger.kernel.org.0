Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 923542F1CF7
	for <lists+kvm@lfdr.de>; Mon, 11 Jan 2021 18:48:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388654AbhAKRse (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Jan 2021 12:48:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727750AbhAKRse (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Jan 2021 12:48:34 -0500
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A39D0C061795
        for <kvm@vger.kernel.org>; Mon, 11 Jan 2021 09:47:53 -0800 (PST)
Received: by mail-wr1-x430.google.com with SMTP id d26so618060wrb.12
        for <kvm@vger.kernel.org>; Mon, 11 Jan 2021 09:47:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=references:user-agent:from:to:cc:subject:date:in-reply-to
         :message-id:mime-version:content-transfer-encoding;
        bh=7PomrZU0jMeuj2pSx76rGsVMpY5/lWRJj77kNrVmTOQ=;
        b=eN3dBxOzR44brDRBdWt3v4cXwY6j30skPdqKuTGRWe/DKoQpXBEbYCNfUfWnxSmOMu
         XBy0JNbmcqHL9/5eTyQHRZK0TylvdmoTIQtrHYnXogIczvSNKQKMvqS2IDa41gSpOeb0
         jCa+KqJnWspIoTNo5Vo72FWylPM+UqOOAL93Y9lhyE/E+JSasH8i1x5Qt4PEIRazuKwW
         47iItS+Yn4S8d/GkngwvwwLE36JBsUFx206rpGBdpMxlY9JBo+PoakQ2ux2Lr1L6YVLy
         T4Sq750nq5cgVMPwYor3Gt9Bgx5x9vcasoQAVPtwwZubrFxLtHxMm/RPTAu3LFDIRtjD
         wmlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject:date
         :in-reply-to:message-id:mime-version:content-transfer-encoding;
        bh=7PomrZU0jMeuj2pSx76rGsVMpY5/lWRJj77kNrVmTOQ=;
        b=fUs/8wmluzHJHGxVQfIighlLnitsW4PbzLzVYsUv8mh+NldJQKT3HqYSapscL0wI9D
         zb7mxLvzFGbpd6X37JMTybhsPozrVBMBwt3qElJtRF1AHCbabccjyHkobzMcNdqoanYK
         cz3ysLHIxo1P46gMb6i6VbPKRjHQP3GmeMuzKdQBDawYvuxz37NS3nTE9CYsH7wclCTr
         XAYvjPt9/N/KEvitRb/DV+xmJxG+3UFxIIAQHxdxKT2M08tPAhLBLm4VztQ98k1UgtPs
         Jg6E8d7W6qziUuZQq7/FwmChbmPCtWMVUEv6XrpnxBCSoHys+qaxJRWBqrCRrjvVg6OJ
         bVGw==
X-Gm-Message-State: AOAM530AZvofHD0Jzf3ej74T34QVq1Xtz15VePjL3d9MfEki5sPTVdE9
        87e+FhLPgcTDU0ffVSBxsYeOAQ==
X-Google-Smtp-Source: ABdhPJyEoJCuSw+5tRtzaJyx6mVyGEBtWFwj20lKG9ywN4EzrcnynxBCh/RF0f45AqXVj56ADnb/VQ==
X-Received: by 2002:a5d:5385:: with SMTP id d5mr269757wrv.384.1610387272416;
        Mon, 11 Jan 2021 09:47:52 -0800 (PST)
Received: from zen.linaroharston ([51.148.130.216])
        by smtp.gmail.com with ESMTPSA id v20sm26616wml.34.2021.01.11.09.47.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Jan 2021 09:47:51 -0800 (PST)
Received: from zen (localhost [127.0.0.1])
        by zen.linaroharston (Postfix) with ESMTP id 8337D1FF7E;
        Mon, 11 Jan 2021 17:47:50 +0000 (GMT)
References: <20210111152020.1422021-1-philmd@redhat.com>
 <20210111152020.1422021-2-philmd@redhat.com>
User-agent: mu4e 1.5.7; emacs 28.0.50
From:   Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
To:     Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@redhat.com>
Cc:     qemu-devel@nongnu.org, Huacai Chen <chenhuacai@kernel.org>,
        Greg Kurz <groug@kaod.org>,
        "Michael S. Tsirkin" <mst@redhat.com>, qemu-trivial@nongnu.org,
        Amit Shah <amit@kernel.org>,
        Dmitry Fleytman <dmitry.fleytman@gmail.com>,
        qemu-arm@nongnu.org, John Snow <jsnow@redhat.com>,
        qemu-s390x@nongnu.org, Paul Durrant <paul@xen.org>,
        Anthony Perard <anthony.perard@citrix.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Kevin Wolf <kwolf@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Max Reitz <mreitz@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Aurelien Jarno <aurelien@aurel32.net>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Jason Wang <jasowang@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        =?utf-8?Q?C=C3=A9dric?= Le Goater <clg@kaod.org>,
        Halil Pasic <pasic@linux.ibm.com>, Fam Zheng <fam@euphon.net>,
        qemu-ppc@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>,
        kvm@vger.kernel.org, Stefano Stabellini <sstabellini@kernel.org>,
        xen-devel@lists.xenproject.org, Cornelia Huck <cohuck@redhat.com>,
        David Hildenbrand <david@redhat.com>, qemu-block@nongnu.org,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Sunil Muthuswamy <sunilmut@microsoft.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Richard Henderson <richard.henderson@linaro.org>,
        Laurent Vivier <laurent@vivier.eu>,
        Thomas Huth <thuth@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>
Subject: Re: [PATCH 1/2] sysemu/runstate: Let runstate_is_running() return bool
Date:   Mon, 11 Jan 2021 17:46:36 +0000
In-reply-to: <20210111152020.1422021-2-philmd@redhat.com>
Message-ID: <87o8hvnz5l.fsf@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Philippe Mathieu-Daud=C3=A9 <philmd@redhat.com> writes:

> runstate_check() returns a boolean. runstate_is_running()
> returns what runstate_check() returns, also a boolean.
>
> Signed-off-by: Philippe Mathieu-Daud=C3=A9 <philmd@redhat.com>

Reviewed-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>

--=20
Alex Benn=C3=A9e
