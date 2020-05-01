Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB6131C18E9
	for <lists+kvm@lfdr.de>; Fri,  1 May 2020 17:05:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728974AbgEAPFx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 May 2020 11:05:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728839AbgEAPFw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 May 2020 11:05:52 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7C0FC061A0C
        for <kvm@vger.kernel.org>; Fri,  1 May 2020 08:05:50 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id f13so11789465wrm.13
        for <kvm@vger.kernel.org>; Fri, 01 May 2020 08:05:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=PoH6jt1DJBDclKJb1eavLYFUm0FbR+rhXmhMnwHv2eg=;
        b=tECm9t6q5LwPWA0k8zPmAqkPYmtf3tBPz1T0Fbzx0C03le9W1PdQNz5lyxXtPbVMuE
         1aMrK37uCpX0Wm4xnzziWPw6yMBpSDcAlqPxTPrBgbSvGoo+S2A99stNM41Vl+fQiJK/
         HfOG6PwvfNOYHiTPpTuShgYYq4XwWTw6A/OQQBxJ63jIzqt9GR962OHsPo1fr/X5IRI4
         xaoPtSzNUTVMcs0t0Zhf8IwqfdXOKu6CrX/MoOli2+w8FQl5McPbjb0vnSLgyc1IQw4x
         fzy3GqxK5Za8OqKRNyTBKcbKAvVYMBJar1g0JRxEQ3TCm3iLp7P+ShU5uyi9f0QKCmI5
         lzPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=PoH6jt1DJBDclKJb1eavLYFUm0FbR+rhXmhMnwHv2eg=;
        b=orKB42TxN63nTgHQ+fCVoTD1Y5nyT6SuhRRMta0+pStPcyE8ekq8V5j3Ce+pz0SaDD
         zRYCllGsXhWeVFdZIIIecUKPpPFl0vzF8ANMrG4DOh77JeUq3w4QluDMb2Q0/3l8R6tq
         32OcwpcZt4/Yjb1KY4yRvwpx9a0MxeoYMX31umwsIcZzNvX/rM9ciiyBfIW0hOFypBsp
         CEuK9cwCJLwl5QJd5ywBXQbGzZlndpi9rZb3aYTUQvksb+KwcZvSJRtZgMCB3DAE8FTi
         OV7OVGG8ESPeEdPBIgtuhrQX6+5sCxLcRR+Ejf8k9xT75zyd0g2RQf4V84BGgvW7gVJw
         XDUw==
X-Gm-Message-State: AGi0PubyJwOepOi/W218UEsYl1JB7rv2yfpqCyix/bmiNi4Jmuf1d/7v
        41zjFU++UeHaqzljBWa8i8w=
X-Google-Smtp-Source: APiQypITW76Q8YkpUdOty7iPZjas1eiHyyCqPbKp3plSq3ZF/hd4+wNZ2HjCFsFdH9FUQpzD062buA==
X-Received: by 2002:adf:f684:: with SMTP id v4mr3172681wrp.218.1588345549493;
        Fri, 01 May 2020 08:05:49 -0700 (PDT)
Received: from localhost ([51.15.41.238])
        by smtp.gmail.com with ESMTPSA id h188sm13929wme.8.2020.05.01.08.05.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 May 2020 08:05:48 -0700 (PDT)
Date:   Fri, 1 May 2020 16:05:47 +0100
From:   Stefan Hajnoczi <stefanha@gmail.com>
To:     Anders =?iso-8859-1?Q?=D6stling?= <anders.ostling@gmail.com>
Cc:     kvm@vger.kernel.org, libvir-list@redhat.com,
        Vladimir Sementsov-Ogievskiy <vsementsov@virtuozzo.com>,
        John Snow <jsnow@redhat.com>, Eric Blake <eblake@redhat.com>,
        qemu-block@nongnu.org, Kashyap Chamarthy <kchamart@redhat.com>
Subject: Re: Backup of vm disk images
Message-ID: <20200501150547.GA221440@stefanha-x1.localdomain>
References: <CAP4+ddND+RrQG7gGoKQ+ydnwXpr0HLrxUyi-pshc-jsigCwjBg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="ReaqsoxgOBHFXBhH"
Content-Disposition: inline
In-Reply-To: <CAP4+ddND+RrQG7gGoKQ+ydnwXpr0HLrxUyi-pshc-jsigCwjBg@mail.gmail.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--ReaqsoxgOBHFXBhH
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 22, 2020 at 07:51:09AM +0200, Anders =D6stling wrote:
> I am fighting to understand the difference between backing up a VM by
> using a regular copy vs using the virsh blockcopy command.
> What I want to do is to suspend the vm, copy the XML and .QCOW2 files
> and then resume the vm again. What are your thoughts? What are the
> drawbacks compared to other methods?

Hi Anders,
The kvm@vger.kernel.org mailing list is mostly for the discussion and
development of the KVM kernel module so you may not get replies.  I have
CCed libvir-list and developers who have been involved in libvirt backup
features.

A naive cp(1) command will be very slow because the entire disk image is
copied to a new file.  The fastest solution with cp(1) is the --reflink
flag which basically takes a snapshot of the file and shares the disk
blocks (only available when the host file system supports it and not
available across mounts).

Libvirt's backup commands are more powerful.  They can do things like
copy out a point-in-time snapshot of the disk while the guest is
running.  They also support incremental backup so you don't need to
store a full copy of the disk image each time you take a backup.

I hope others will join the discussion and give examples of some of the
available features.

Stefan

--ReaqsoxgOBHFXBhH
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl6sOsoACgkQnKSrs4Gr
c8hPawf9HQN6I/s9Pb80GKVYBkQDLBd4K5BH8JPNozYDAwziYHxmgnv1YU/0hP+L
tuPZT9pVQs4BSxlP1Qy4WdLfZzNIq6rtktAcSZiHDoBdNN5GB50Y+tZc/fKX/HFZ
allmP7fw+JnEIHDuQqdKfRXz3N9hOrnYb5B3/6YXvc90ROojc1PIWdf64/qAbx+m
3XHtcgMyGM4QRaYV5MLa9Bdr1VS+ntCMyS4XxEsQBU8AyNqBGLu3ZY5vjyBoIx8O
KTyGFU0BRE1JII8FlxZZEGA6Om9vAdxXiqrRwIk2RO9vViKQ448GKYLZYYR8t1F9
O5QYX3siA946sTuLZ9BRBTZHaKWdvQ==
=3Co8
-----END PGP SIGNATURE-----

--ReaqsoxgOBHFXBhH--
