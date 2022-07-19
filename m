Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63796578F66
	for <lists+kvm@lfdr.de>; Tue, 19 Jul 2022 02:46:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236310AbiGSAq2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Jul 2022 20:46:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235005AbiGSAq1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Jul 2022 20:46:27 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EF7D286C9;
        Mon, 18 Jul 2022 17:46:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658191585; x=1689727585;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   mime-version:in-reply-to;
  bh=hyF5/QVeyyEx7k2cC1g6wG/l/r4YcdMqKEwUQCPZNls=;
  b=gru+0j5jsKmhQ3QcjyZqu4MX5N4JcYXjcx49PhVmDXW3+Tl0WJ9nE6DH
   BKi1Yh2hiKmRzTKqxSYqOuFP6c3x+L1sXZXBsuj7H/jqL06+TLPy1rzv0
   KC4U23eUjAggFr/ywBmBDE1+qDB+/r+3rIJwcnZTtwnuXZ24esg69XN9h
   3WAR4x6EFRXt9dqV/uRRq5aKP27n39B2I77pPsQSZ7IDAwBFfMbmLDrHB
   RKq/YhOeh8D0CTARa/ZVwPgnaKzNI8kP5VnztYkPjwwHNQJaMh3al00Ow
   gDua7aik20w+m01HpPlywwbY1Bplv0zu8R6eihaSKcF1fKDOvV0ozzd3i
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10412"; a="372659171"
X-IronPort-AV: E=Sophos;i="5.92,282,1650956400"; 
   d="asc'?scan'208";a="372659171"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2022 17:46:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,282,1650956400"; 
   d="asc'?scan'208";a="655514201"
Received: from zhen-hp.sh.intel.com (HELO zhen-hp) ([10.239.159.108])
  by fmsmga008.fm.intel.com with ESMTP; 18 Jul 2022 17:46:22 -0700
Date:   Tue, 19 Jul 2022 08:22:40 +0800
From:   Zhenyu Wang <zhenyuw@linux.intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, intel-gvt-dev@lists.freedesktop.org
Subject: Re: simplify the mdev interface v6
Message-ID: <20220719002240.GD1089@zhen-hp.sh.intel.com>
Reply-To: Zhenyu Wang <zhenyuw@linux.intel.com>
References: <20220709045450.609884-1-hch@lst.de>
 <20220718054348.GA22345@lst.de>
 <20220718153331.18a52e31.alex.williamson@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="bJBxXK1kQfYiHILX"
Content-Disposition: inline
In-Reply-To: <20220718153331.18a52e31.alex.williamson@redhat.com>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--bJBxXK1kQfYiHILX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2022.07.18 15:33:31 -0600, Alex Williamson wrote:
> On Mon, 18 Jul 2022 07:43:48 +0200
> Christoph Hellwig <hch@lst.de> wrote:
>=20
> > Alex, does this series look good to you now?
>=20
> It does.  I was hoping we'd get a more complete set acks from the mdev
> driver owners, but I'll grab this within the next day or two with
> whatever additional reviews come in by then.  Thanks,
>=20

No problem for me to merge gvt changes through your pull. Thanks!

--bJBxXK1kQfYiHILX
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EARECAB0WIQTXuabgHDW6LPt9CICxBBozTXgYJwUCYtX5RwAKCRCxBBozTXgY
JzTyAJ0TuYiKA/2YyFpOV9JjQNJFujxvAgCfQg9MD1AzSUfXw+c98NHNX9rB+DE=
=vjqj
-----END PGP SIGNATURE-----

--bJBxXK1kQfYiHILX--
