Return-Path: <kvm+bounces-20672-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8242A91BFC9
	for <lists+kvm@lfdr.de>; Fri, 28 Jun 2024 15:43:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2B69F1F2355D
	for <lists+kvm@lfdr.de>; Fri, 28 Jun 2024 13:43:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B7BFF1BE854;
	Fri, 28 Jun 2024 13:42:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="D7SP6Doy"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17C851E495;
	Fri, 28 Jun 2024 13:42:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719582169; cv=none; b=hxJ+/1474HUFTuu4/52cT2DlYLBfvqZapy/cPB3jd0dr3jryDejL01Jrj8ln2A9MLfcV5FgTQpePokSv/lyY9nvGMYccBecG/AGxNLnZ1I2UFRag5IqLS1lTJF/Vsobnp8T5+7EhlDDyQ9K7g0IGi0/4rzFi/2JWLa87AoDlfwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719582169; c=relaxed/simple;
	bh=ssHzJIF7S2KHuKDb9h3C0C+M5ebYBvfbT9APzG7dWSE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uWBEWZsyh6S74uI63E0+VzhBBj8FQT7D+ohcFkMBdmgXGvR6bT+BYjZrwu2jML00Z0uIyYiUMTHQxhcjHotGK5ESbojg1yYGktRcww+WdBV0W075m78jPQ01IVJmxCgMnUeDiXA060bLGrsTu022G46NPTtFRkDoSzgG8DTikNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=D7SP6Doy; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1719582168; x=1751118168;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ssHzJIF7S2KHuKDb9h3C0C+M5ebYBvfbT9APzG7dWSE=;
  b=D7SP6DoyBaA5s1v3ctQeFko9ekXSlOa890Dw4gZcuNxTqKtMHwqO3g6Y
   ngjggBsiEWdpEETmeb3hp+m5bNRjyaWvcHeCsCam3NFqm+WQWrFlZbPBh
   Tzpa1b1Xs38HdoPLYoZ9hdnVouoS+TWQFZfMz8VWKLU/ntFTaHq8EX4qE
   2PNbVgWF54Pdm+fQU+HS+4sQ9xtJaekMbi7OTWmxO9ZQnHrnyIApFhzv+
   j+WeUIhdAFsGaAOXVWxxbZvAf1wSZ2Qv19kJe5IH9ObLpHSm/Y8zxirob
   P9pUf6QVxplZo6x4L5JRaG6irmNv89FtwTpJzYCwfJsbNLPsOFhpQN66u
   A==;
X-CSE-ConnectionGUID: 4tImmCVqShSErpJkIEnKIA==
X-CSE-MsgGUID: HicpljxjSwa7lbdNf3v0Lg==
X-IronPort-AV: E=McAfee;i="6700,10204,11117"; a="16599310"
X-IronPort-AV: E=Sophos;i="6.09,169,1716274800"; 
   d="scan'208";a="16599310"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2024 06:42:47 -0700
X-CSE-ConnectionGUID: GRkHS0RpTkGGdO3JdZ3Ytw==
X-CSE-MsgGUID: 2Wo/Ldk7TPWz5O0SRuc0MA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,169,1716274800"; 
   d="scan'208";a="67941648"
Received: from lkp-server01.sh.intel.com (HELO 68891e0c336b) ([10.239.97.150])
  by fmviesa002.fm.intel.com with ESMTP; 28 Jun 2024 06:42:43 -0700
Received: from kbuild by 68891e0c336b with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1sNBs9-000H9S-2C;
	Fri, 28 Jun 2024 13:42:41 +0000
Date: Fri, 28 Jun 2024 21:42:27 +0800
From: kernel test robot <lkp@intel.com>
To: Luigi Leonardi via B4 Relay <devnull+luigi.leonardi.outlook.com@kernel.org>,
	Stefano Garzarella <sgarzare@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc: oe-kbuild-all@lists.linux.dev, netdev@vger.kernel.org,
	virtualization@lists.linux.dev, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, Luigi Leonardi <luigi.leonardi@outlook.com>,
	Daan De Meyer <daan.j.demeyer@gmail.com>
Subject: Re: [PATCH net-next v3 1/3] vsock: add support for SIOCOUTQ ioctl
 for all vsock socket types.
Message-ID: <202406282144.DxR5KwIu-lkp@intel.com>
References: <20240626-ioctl_next-v3-1-63be5bf19a40@outlook.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240626-ioctl_next-v3-1-63be5bf19a40@outlook.com>

Hi Luigi,

kernel test robot noticed the following build warnings:

[auto build test WARNING on 50b70845fc5c22cf7e7d25b57d57b3dca1725aa5]

url:    https://github.com/intel-lab-lkp/linux/commits/Luigi-Leonardi-via-B4-Relay/vsock-add-support-for-SIOCOUTQ-ioctl-for-all-vsock-socket-types/20240627-023902
base:   50b70845fc5c22cf7e7d25b57d57b3dca1725aa5
patch link:    https://lore.kernel.org/r/20240626-ioctl_next-v3-1-63be5bf19a40%40outlook.com
patch subject: [PATCH net-next v3 1/3] vsock: add support for SIOCOUTQ ioctl for all vsock socket types.
config: i386-randconfig-141-20240628 (https://download.01.org/0day-ci/archive/20240628/202406282144.DxR5KwIu-lkp@intel.com/config)
compiler: gcc-8 (Ubuntu 8.4.0-3ubuntu2) 8.4.0

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202406282144.DxR5KwIu-lkp@intel.com/

smatch warnings:
net/vmw_vsock/af_vsock.c:1321 vsock_do_ioctl() warn: unsigned 'n_bytes' is never less than zero.

vim +/n_bytes +1321 net/vmw_vsock/af_vsock.c

  1295	
  1296	static int vsock_do_ioctl(struct socket *sock, unsigned int cmd,
  1297				  int __user *arg)
  1298	{
  1299		struct sock *sk = sock->sk;
  1300		struct vsock_sock *vsk;
  1301		int retval;
  1302	
  1303		vsk = vsock_sk(sk);
  1304	
  1305		switch (cmd) {
  1306		case SIOCOUTQ: {
  1307			size_t n_bytes;
  1308	
  1309			if (!vsk->transport || !vsk->transport->unsent_bytes) {
  1310				retval = -EOPNOTSUPP;
  1311				break;
  1312			}
  1313	
  1314			if (vsk->transport->unsent_bytes) {
  1315				if (sock_type_connectible(sk->sk_type) && sk->sk_state == TCP_LISTEN) {
  1316					retval = -EINVAL;
  1317					break;
  1318				}
  1319	
  1320				n_bytes = vsk->transport->unsent_bytes(vsk);
> 1321				if (n_bytes < 0) {
  1322					retval = n_bytes;
  1323					break;
  1324				}
  1325	
  1326				retval = put_user(n_bytes, arg);
  1327			}
  1328			break;
  1329		}
  1330		default:
  1331			retval = -ENOIOCTLCMD;
  1332		}
  1333	
  1334		return retval;
  1335	}
  1336	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

