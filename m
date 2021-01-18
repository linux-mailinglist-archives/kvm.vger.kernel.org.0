Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDC362F9A0C
	for <lists+kvm@lfdr.de>; Mon, 18 Jan 2021 07:41:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732709AbhARGlK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Jan 2021 01:41:10 -0500
Received: from wnew4-smtp.messagingengine.com ([64.147.123.18]:45621 "EHLO
        wnew4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732714AbhARGkn (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 18 Jan 2021 01:40:43 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.west.internal (Postfix) with ESMTP id 318C615DB;
        Mon, 18 Jan 2021 01:39:13 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 18 Jan 2021 01:39:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=flygoat.com; h=
        from:to:cc:subject:date:message-id:in-reply-to:references
        :mime-version:content-transfer-encoding; s=fm1; bh=yDi3rR9AlpqoZ
        Pff7ititIXIq7aDJehwY82Gzczm7E0=; b=Xs1Xs32fAu+tIcIncKODym0Mbvxkv
        w4hiLo05Xll3jpwwYmrU9heNJn6jnJNXVHXIo3NPoVcRN00CDuNZstGfAwP85HXE
        WiymN5G6K0C8HSAT5tvAkEjIdoxyTDs6MmpqG2W/XfhcYMSSlJ0D2eedTJA7gemQ
        /tMg4Lztl/h5+zKirk5iIBq5bzCDFoiZ+HVqQJYzwHJqNaU8p2DR27X+o7zrfM1/
        fUXHeLZ5umI0KpBBIdrUQqGJVT2Zt019Pe/N2IAMYPzZuJDBYeQ168Zf0pe1hVdN
        kYmUjgHPaeY6RZ0JDOpqw8JIzEL24b9khvGYvJKODrmfggIHD97FCdFBA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=yDi3rR9AlpqoZPff7ititIXIq7aDJehwY82Gzczm7E0=; b=GbbUBH5e
        xFrVODVI70fe2WsmMF5YADHM+VCKPr7LdJH0ilRa7dxRbX664HU7EGHPDrRzfWk8
        jAG3S1CYDTClCTr4Gc+WK577qdhyCmlZgFOidkjsRJgZI1/PX/OtwliJE4ohjWrL
        /6PA42tqtq4Phxh+KTwFYApJbbUyxQRSjpXFdCxXWEBk3lok6iMrucOwItbvkWpl
        qJMzUm6bcAOJuljexvsbXuPIXpdJp+2ihgI+1mpFZyz0EIlBDbQtsht3jYeHMlGd
        Yn4jOEIZ3CpFCRxe4jKTVc1ZiLAuEXEIevHHgGpvmFgNT4HxbEtpxu96x4Z+28Pv
        nWcDjMPIsoHlMA==
X-ME-Sender: <xms:Dy0FYAM3KZeQyKQ5_r98gQLmRtWsc5WQAJLxiY4v2nIEAdXHNY8esQ>
    <xme:Dy0FYLQJVVKmO0GGtkn-xlrGduJVMKELAno2O666EB18CrfWBjWYy5uXey_f5X84m
    a1nk2ESjgrKE1DNDtk>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrtdejgdeljecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefhvffufffkofgjfhgggfestdekredtredttdenucfhrhhomheplfhirgiguhhn
    ucgjrghnghcuoehjihgrgihunhdrhigrnhhgsehflhihghhorghtrdgtohhmqeenucggtf
    frrghtthgvrhhnpeejuefhkeegheehffetgfeuveeuvdeukeevkeeigeduhffhgfdvvdeh
    hefhfffhudenucffohhmrghinheprghlphhinhgvlhhinhhugidrohhrghenucfkphepud
    duiedrvddvkedrkeegrddvnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehm
    rghilhhfrhhomhepjhhirgiguhhnrdihrghnghesfhhlhihgohgrthdrtghomh
X-ME-Proxy: <xmx:Dy0FYGaMcVpS_GvjPteAHeVa01fJvyXKGSeOyRKz62xqrJZaCD6DBg>
    <xmx:Dy0FYA1jVhpbIi4j0RwMDnf5E6mxJbZq4_ecqxCz8tUayBWdhaNHIg>
    <xmx:Dy0FYOXiP55YfThQoV3kEQgLQ5QPCXFdmfYFRnr3a4j1WbnIRzm4og>
    <xmx:EC0FYA3PfCH4s5O1JJhIjhx60iXNwqMGf3ozt6_SY54gl_JWsqxfwRfdj5bV2IPD>
Received: from strike.U-LINK.com (unknown [116.228.84.2])
        by mail.messagingengine.com (Postfix) with ESMTPA id 090C524005B;
        Mon, 18 Jan 2021 01:39:05 -0500 (EST)
From:   Jiaxun Yang <jiaxun.yang@flygoat.com>
To:     qemu-devel@nongnu.org
Cc:     David Gibson <david@gibson.dropbear.id.au>, qemu-ppc@nongnu.org,
        Greg Kurz <groug@kaod.org>, Max Reitz <mreitz@redhat.com>,
        kvm@vger.kernel.org,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        Wainer dos Santos Moschetta <wainersm@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Fam Zheng <fam@euphon.net>,
        Viktor Prutyanov <viktor.prutyanov@phystech.edu>,
        Alistair Francis <alistair@alistair23.me>,
        Thomas Huth <thuth@redhat.com>,
        Laurent Vivier <lvivier@redhat.com>,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        qemu-block@nongnu.org, Kevin Wolf <kwolf@redhat.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>
Subject: [PATCH v2 8/9] tests/docker: Add dockerfile for Alpine Linux
Date:   Mon, 18 Jan 2021 14:38:07 +0800
Message-Id: <20210118063808.12471-9-jiaxun.yang@flygoat.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210118063808.12471-1-jiaxun.yang@flygoat.com>
References: <20210118063808.12471-1-jiaxun.yang@flygoat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Alpine Linux[1] is a security-oriented, lightweight Linux distribution
based on musl libc and busybox.

It it popular among Docker guests and embedded applications.

Adding it to test against different libc.

[1]: https://alpinelinux.org/

Signed-off-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
---
 tests/docker/dockerfiles/alpine.docker | 57 ++++++++++++++++++++++++++
 1 file changed, 57 insertions(+)
 create mode 100644 tests/docker/dockerfiles/alpine.docker

diff --git a/tests/docker/dockerfiles/alpine.docker b/tests/docker/dockerfiles/alpine.docker
new file mode 100644
index 0000000000..5be5198d00
--- /dev/null
+++ b/tests/docker/dockerfiles/alpine.docker
@@ -0,0 +1,57 @@
+
+FROM alpine:edge
+
+RUN apk update
+RUN apk upgrade
+
+# Please keep this list sorted alphabetically
+ENV PACKAGES \
+	alsa-lib-dev \
+	bash \
+	bison \
+	build-base \
+	coreutils \
+	curl-dev \
+	flex \
+	git \
+	glib-dev \
+	glib-static \
+	gnutls-dev \
+	gtk+3.0-dev \
+	libaio-dev \
+	libcap-dev \
+	libcap-ng-dev \
+	libjpeg-turbo-dev \
+	libnfs-dev \
+	libpng-dev \
+	libseccomp-dev \
+	libssh-dev \
+	libusb-dev \
+	libxml2-dev \
+	linux-headers \
+	lzo-dev \
+	mesa-dev \
+	mesa-egl \
+	mesa-gbm \
+	meson \
+	ncurses-dev \
+	ninja \
+	paxmark \
+	perl \
+	pulseaudio-dev \
+	python3 \
+	py3-sphinx \
+	shadow \
+	snappy-dev \
+	spice-dev \
+	texinfo \
+	usbredir-dev \
+	util-linux-dev \
+	vde2-dev \
+	virglrenderer-dev \
+	vte3-dev \
+	xfsprogs-dev \
+	zlib-dev \
+	zlib-static
+
+RUN apk add $PACKAGES
-- 
2.30.0

