Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 279CF1D62D5
	for <lists+kvm@lfdr.de>; Sat, 16 May 2020 19:01:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726296AbgEPRBl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 16 May 2020 13:01:41 -0400
Received: from mga06.intel.com ([134.134.136.31]:5013 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726252AbgEPRBl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 16 May 2020 13:01:41 -0400
IronPort-SDR: u2+P6fltaRRzEacRvehuBblVQScD0jFdzt1s45lnr+tw1OK6iDapYMNimVjy0enWb2b/3Bli1V
 CFlQ03RSx88g==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 May 2020 10:01:40 -0700
IronPort-SDR: r+sK0gl7anOBagUulkgWHCqnkExUoWoJJ4KRv2v6jMnmm3TI7iFFC5b3X4/f0Hqml7OuKUqpXq
 bOfCqwcd9YLQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,398,1583222400"; 
   d="scan'208";a="299357258"
Received: from matedfor-mobl.amr.corp.intel.com (HELO [10.251.2.113]) ([10.251.2.113])
  by orsmga008.jf.intel.com with ESMTP; 16 May 2020 10:01:39 -0700
Subject: Re: [Sound-open-firmware] [PATCH 5/6] vhost: add an rpmsg API
To:     Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>,
        kvm@vger.kernel.org
Cc:     linux-remoteproc@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        sound-open-firmware@alsa-project.org,
        Liam Girdwood <liam.r.girdwood@linux.intel.com>
References: <20200516101109.2624-1-guennadi.liakhovetski@linux.intel.com>
 <20200516101109.2624-6-guennadi.liakhovetski@linux.intel.com>
From:   Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Message-ID: <9737e3f2-e59c-0174-9254-a2d8f29f30b7@linux.intel.com>
Date:   Sat, 16 May 2020 12:00:35 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200516101109.2624-6-guennadi.liakhovetski@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


> +config VHOST_RPMSG
> +	tristate
> +	depends on VHOST

depends on RPMSG_VIRTIO?

> +	default n

not needed


