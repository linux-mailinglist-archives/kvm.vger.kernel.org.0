Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42EE12813CD
	for <lists+kvm@lfdr.de>; Fri,  2 Oct 2020 15:15:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726569AbgJBNPH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Oct 2020 09:15:07 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:36517 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726017AbgJBNPH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 2 Oct 2020 09:15:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601644506;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type;
        bh=7Q2+Dg7abeldWpVMdz/K+uE/ec+umHQILXtvkjCFi5Y=;
        b=VJ6F/Z+/xwX+afTwg7Mi3iuOYnc6p/YTRy4WyizxPrG++O3iwMbEqDubrSEPGyL2pqMI01
        WTYPZwQpnQzh2C/FrSEJ3z2xq2EhQoLlLCRnIpNGm1Phl6DdenMFTEByqjbgWSDtRLKEF0
        p6ctikHZwzQSRBRktmGnuBN7hUjfP0s=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-41-AnxVtaU1O_yKgd6zhsBwNQ-1; Fri, 02 Oct 2020 09:14:58 -0400
X-MC-Unique: AnxVtaU1O_yKgd6zhsBwNQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 04C681021215;
        Fri,  2 Oct 2020 13:14:56 +0000 (UTC)
Received: from localhost (ovpn-114-195.ams2.redhat.com [10.36.114.195])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9BBC379981;
        Fri,  2 Oct 2020 13:14:55 +0000 (UTC)
Date:   Fri, 2 Oct 2020 14:14:54 +0100
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     qemu-devel@nongnu.org, kvm@vger.kernel.org
Subject: Call for KVM Forum panel discussion topics
Message-ID: <20201002131454.GB574544@stefanha-x1.localdomain>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=stefanha@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="cvVnyQ+4j833TQvp"
Content-Disposition: inline
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--cvVnyQ+4j833TQvp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,
You can post questions for the KVM Forum panel discussion until October
13th:
https://etherpad.opendev.org/p/KVMForum_2020_Panel

The panel is a yearly session at KVM Forum for discussing technical and
non-technical topics related to KVM, QEMU, and open source
virtualization in general. The panelists are developers, managers,
researchers, and others involved in open source virtualization.

Questions and topics come from the community, so please participate!

The panelists this year are:
 * Susie Li - Software Engineering Director, Intel
 * Hubertus Franke - Distinguished Research Staff Member, IBM
 * David Kaplan - Fellow, AMD
 * Peter Maydell - Principal Software Engineer, ARM
 * Richard W.M. Jones - Senior Principal Software Engineer, Red Hat

The panel session is on Wednesday, October 28th at KVM Forum 2020:
https://sched.co/eE2D

Last year's session is available for watching here:
https://www.youtube.com/watch?v=8lmiZeh-xC0

Stefan

--cvVnyQ+4j833TQvp
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl93J84ACgkQnKSrs4Gr
c8iCaAf9GnfOnphKYUzFCJewaJfQm8IRTWlC27e78ilSZxbQPylTK3yRvekVcHFb
zQGy3/AnPcfjrYFMDpzY/T2ko7kp8tFiP+e1Kk8LzlaUlGuK5Y8rUp/Ws6LNNgM1
l75cSEAi+JmbqCJjDPMQC1sObbHugDFpshSC+y2xQByYXXpbMKuZSB7I4YCkeJ61
j5SmkFED821KHyVbjIXlTNDgTPXfw7g2RHcKXeNZHPhUtYrorsxMLbGJZArzcEgs
R+LnU05zCr6CkjOFfBozT/iozww5OKXIDep/gJ3fFY7+3g0I1Vv78v5ysxIOpa0V
5P1EFljNL8NJ/Har3Z2IxuAyg1qiiA==
=R6LZ
-----END PGP SIGNATURE-----

--cvVnyQ+4j833TQvp--

