Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16756221E5C
	for <lists+kvm@lfdr.de>; Thu, 16 Jul 2020 10:30:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727795AbgGPIaW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Jul 2020 04:30:22 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:55739 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725965AbgGPIaU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 16 Jul 2020 04:30:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594888219;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=uMoV8E+m5h5G1BnU+d26SjEaGY2v9TCqvbbDkS+Gs3I=;
        b=D19PB6OfsYzpXyvmGZ+LpkV2z60wQvHr5rtjCQ9mOajq1gUagWHRzaLpMiDSOLdZG1SLiT
        0vZV/v8u69TKVkuz/ZQ2Ck30xyz1k4d99/FKbHJAoCkuBqKTn4jQkh0kMMN/UO7SnBe88i
        DUL4IN209XyiiT7Y/FHFSKQvGTtGh3I=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-464-8Q1H_v9oMAyDRBo8bl_bgw-1; Thu, 16 Jul 2020 04:30:15 -0400
X-MC-Unique: 8Q1H_v9oMAyDRBo8bl_bgw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0FC67100AA23;
        Thu, 16 Jul 2020 08:30:13 +0000 (UTC)
Received: from localhost (ovpn-115-67.ams2.redhat.com [10.36.115.67])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 612785C1D3;
        Thu, 16 Jul 2020 08:30:11 +0000 (UTC)
Date:   Thu, 16 Jul 2020 09:30:10 +0100
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Andra Paraschiv <andraprs@amazon.com>
Cc:     linux-kernel@vger.kernel.org,
        Anthony Liguori <aliguori@amazon.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Colm MacCarthaigh <colmmacc@amazon.com>,
        David Duncan <davdunc@amazon.com>,
        Bjoern Doebel <doebel@amazon.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Frank van der Linden <fllinden@amazon.com>,
        Alexander Graf <graf@amazon.de>,
        Greg KH <gregkh@linuxfoundation.org>,
        Karen Noel <knoel@redhat.com>,
        Martin Pohlack <mpohlack@amazon.de>,
        Matt Wilson <msw@amazon.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Balbir Singh <sblbir@amazon.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Stewart Smith <trawets@amazon.com>,
        Uwe Dannowski <uwed@amazon.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        ne-devel-upstream@amazon.com, Alexander Graf <graf@amazon.com>
Subject: Re: [PATCH v5 01/18] nitro_enclaves: Add ioctl interface definition
Message-ID: <20200716083010.GA85868@stefanha-x1.localdomain>
References: <20200715194540.45532-1-andraprs@amazon.com>
 <20200715194540.45532-2-andraprs@amazon.com>
MIME-Version: 1.0
In-Reply-To: <20200715194540.45532-2-andraprs@amazon.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="wac7ysb48OaltWcw"
Content-Disposition: inline
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--wac7ysb48OaltWcw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jul 15, 2020 at 10:45:23PM +0300, Andra Paraschiv wrote:
> + * A NE CPU pool has be set before calling this function. The pool can be set

s/has be/has to be/

Thanks, this looks good!

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--wac7ysb48OaltWcw
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl8QEBIACgkQnKSrs4Gr
c8i6rwf+Oe8511/+srbVnceLKWZZxWatJOMF1O3dlpLW/88QdVfFnZuuX3BRm4Fe
xIFCsDEWmM3cIp/sTF8M/SxKJvxtHXdUsMOO19AoPhlZkzcOn/X3noqDhIqVyTeT
w56472iAmr10oEeZZijlf08MH+Grzri+o2EtDhJ1wb8Ng9+ymcDO2Tuxlpat1JA2
KikNEZaXOiX7bYShgu/OemyVOxt+2LMnx/vwH7caelluL4Kqt4jeYpGcTuAMRBJG
wR7qFTmVnpr9sW+jGAAWxFvEL9qzR7YGvODguZpUmwfFz99YQIdx0cu/9eH21T5J
SuzKo7xxc5xBkdVWtfB+YAIxkcc8MQ==
=DVjx
-----END PGP SIGNATURE-----

--wac7ysb48OaltWcw--

