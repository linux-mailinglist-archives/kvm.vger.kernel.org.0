Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E098565EDE
	for <lists+kvm@lfdr.de>; Mon,  4 Jul 2022 23:22:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233178AbiGDVV5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Jul 2022 17:21:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232389AbiGDVVz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Jul 2022 17:21:55 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AEDC6366;
        Mon,  4 Jul 2022 14:21:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656969714; x=1688505714;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=CYi8Rh5YnjrapcX+sT0MPxpiE7tDmLImz6R+zGheklw=;
  b=GzSUwwW5mMlfWQI8I+8IoZEiEEJrxOrrA8rTOvti7LsjDNGlKC0sDF3j
   usIivaXZzseJISTuFbcUr5jCM0Jrvp1NndscQUG3wC8au99Y554xf8gds
   b2p+khWDD77PF6h+gpFp1lgrHQQL8mZXWw7RxaVSwZK9aFeqwL6hFmJ2N
   xerysLWbvZUQZrSBu2LHUoKo1Rk9auuwSqSsG5gX78Bt49ONsqXjS7Zgg
   Y2BiVLzXa/IYy/YMacDNT5AGvLjjEct3VwH+Nflx3YIGixKSEqW/HfQAg
   u34nc18Yd4LlfnSGc19BhvAx+6FLJFRVl50+qp2S/3IoLUAJ+XEKof96d
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10398"; a="347178176"
X-IronPort-AV: E=Sophos;i="5.92,243,1650956400"; 
   d="scan'208";a="347178176"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jul 2022 14:21:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,243,1650956400"; 
   d="scan'208";a="625175303"
Received: from lkp-server01.sh.intel.com (HELO 68b931ab7ac1) ([10.239.97.150])
  by orsmga001.jf.intel.com with ESMTP; 04 Jul 2022 14:21:50 -0700
Received: from kbuild by 68b931ab7ac1 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1o8TVt-000IBE-NZ;
        Mon, 04 Jul 2022 21:21:49 +0000
Date:   Tue, 5 Jul 2022 05:20:53 +0800
From:   kernel test robot <lkp@intel.com>
To:     Tony Krowiak <akrowiak@linux.ibm.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     kbuild-all@lists.01.org, jjherne@linux.ibm.com,
        freude@linux.ibm.com, borntraeger@de.ibm.com, cohuck@redhat.com,
        mjrosato@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com
Subject: Re: [PATCH v20 18/20] s390/vfio-ap: update docs to include dynamic
 config support
Message-ID: <202207050533.oQ9M1DAt-lkp@intel.com>
References: <20220621155134.1932383-19-akrowiak@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220621155134.1932383-19-akrowiak@linux.ibm.com>
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Tony,

I love your patch! Perhaps something to improve:

[auto build test WARNING on s390/features]
[also build test WARNING on mst-vhost/linux-next linus/master v5.19-rc5 next-20220704]
[cannot apply to kvms390/next]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/intel-lab-lkp/linux/commits/Tony-Krowiak/s390-vfio-ap-dynamic-configuration-support/20220621-235654
base:   https://git.kernel.org/pub/scm/linux/kernel/git/s390/linux.git features
reproduce: make htmldocs

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

>> Documentation/s390/vfio-ap.rst:684: WARNING: Inline strong start-string without end-string.
>> Documentation/s390/vfio-ap.rst:684: WARNING: Inline emphasis start-string without end-string.
>> Documentation/s390/vfio-ap.rst:943: WARNING: Title underline too short.
>> Documentation/s390/vfio-ap.rst:998: WARNING: Definition list ends without a blank line; unexpected unindent.

vim +684 Documentation/s390/vfio-ap.rst

   538	
   539	1. Install the vfio_ap module on the linux host. The dependency chain for the
   540	   vfio_ap module is:
   541	   * iommu
   542	   * s390
   543	   * zcrypt
   544	   * vfio
   545	   * vfio_mdev
   546	   * vfio_mdev_device
   547	   * KVM
   548	
   549	   To build the vfio_ap module, the kernel build must be configured with the
   550	   following Kconfig elements selected:
   551	   * IOMMU_SUPPORT
   552	   * S390
   553	   * ZCRYPT
   554	   * S390_AP_IOMMU
   555	   * VFIO
   556	   * VFIO_MDEV
   557	   * KVM
   558	
   559	   If using make menuconfig select the following to build the vfio_ap module::
   560	
   561	     -> Device Drivers
   562		-> IOMMU Hardware Support
   563		   select S390 AP IOMMU Support
   564		-> VFIO Non-Privileged userspace driver framework
   565		   -> Mediated device driver frramework
   566		      -> VFIO driver for Mediated devices
   567	     -> I/O subsystem
   568		-> VFIO support for AP devices
   569	
   570	2. Secure the AP queues to be used by the three guests so that the host can not
   571	   access them. To secure them, there are two sysfs files that specify
   572	   bitmasks marking a subset of the APQN range as usable only by the default AP
   573	   queue device drivers. All remaining APQNs are available for use by
   574	   any other device driver. The vfio_ap device driver is currently the only
   575	   non-default device driver. The location of the sysfs files containing the
   576	   masks are::
   577	
   578	     /sys/bus/ap/apmask
   579	     /sys/bus/ap/aqmask
   580	
   581	   The 'apmask' is a 256-bit mask that identifies a set of AP adapter IDs
   582	   (APID). Each bit in the mask, from left to right, corresponds to an APID from
   583	   0-255. If a bit is set, the APID belongs to the subset of APQNs marked as
   584	   available only to the default AP queue device drivers.
   585	
   586	   The 'aqmask' is a 256-bit mask that identifies a set of AP queue indexes
   587	   (APQI). Each bit in the mask, from left to right, corresponds to an APQI from
   588	   0-255. If a bit is set, the APQI belongs to the subset of APQNs marked as
   589	   available only to the default AP queue device drivers.
   590	
   591	   The Cartesian product of the APIDs corresponding to the bits set in the
   592	   apmask and the APQIs corresponding to the bits set in the aqmask comprise
   593	   the subset of APQNs that can be used only by the host default device drivers.
   594	   All other APQNs are available to the non-default device drivers such as the
   595	   vfio_ap driver.
   596	
   597	   Take, for example, the following masks::
   598	
   599	      apmask:
   600	      0x7d00000000000000000000000000000000000000000000000000000000000000
   601	
   602	      aqmask:
   603	      0x8000000000000000000000000000000000000000000000000000000000000000
   604	
   605	   The masks indicate:
   606	
   607	   * Adapters 1, 2, 3, 4, 5, and 7 are available for use by the host default
   608	     device drivers.
   609	
   610	   * Domain 0 is available for use by the host default device drivers
   611	
   612	   * The subset of APQNs available for use only by the default host device
   613	     drivers are:
   614	
   615	     (1,0), (2,0), (3,0), (4.0), (5,0) and (7,0)
   616	
   617	   * All other APQNs are available for use by the non-default device drivers.
   618	
   619	   The APQN of each AP queue device assigned to the linux host is checked by the
   620	   AP bus against the set of APQNs derived from the Cartesian product of APIDs
   621	   and APQIs marked as available to the default AP queue device drivers. If a
   622	   match is detected,  only the default AP queue device drivers will be probed;
   623	   otherwise, the vfio_ap device driver will be probed.
   624	
   625	   By default, the two masks are set to reserve all APQNs for use by the default
   626	   AP queue device drivers. There are two ways the default masks can be changed:
   627	
   628	   1. The sysfs mask files can be edited by echoing a string into the
   629	      respective sysfs mask file in one of two formats:
   630	
   631	      * An absolute hex string starting with 0x - like "0x12345678" - sets
   632		the mask. If the given string is shorter than the mask, it is padded
   633		with 0s on the right; for example, specifying a mask value of 0x41 is
   634		the same as specifying::
   635	
   636		   0x4100000000000000000000000000000000000000000000000000000000000000
   637	
   638		Keep in mind that the mask reads from left to right, so the mask
   639		above identifies device numbers 1 and 7 (01000001).
   640	
   641		If the string is longer than the mask, the operation is terminated with
   642		an error (EINVAL).
   643	
   644	      * Individual bits in the mask can be switched on and off by specifying
   645		each bit number to be switched in a comma separated list. Each bit
   646		number string must be prepended with a ('+') or minus ('-') to indicate
   647		the corresponding bit is to be switched on ('+') or off ('-'). Some
   648		valid values are:
   649	
   650		   - "+0"    switches bit 0 on
   651		   - "-13"   switches bit 13 off
   652		   - "+0x41" switches bit 65 on
   653		   - "-0xff" switches bit 255 off
   654	
   655		The following example:
   656	
   657		      +0,-6,+0x47,-0xf0
   658	
   659		Switches bits 0 and 71 (0x47) on
   660	
   661		Switches bits 6 and 240 (0xf0) off
   662	
   663		Note that the bits not specified in the list remain as they were before
   664		the operation.
   665	
   666	   2. The masks can also be changed at boot time via parameters on the kernel
   667	      command line like this:
   668	
   669		 ap.apmask=0xffff ap.aqmask=0x40
   670	
   671		 This would create the following masks::
   672	
   673		    apmask:
   674		    0xffff000000000000000000000000000000000000000000000000000000000000
   675	
   676		    aqmask:
   677		    0x4000000000000000000000000000000000000000000000000000000000000000
   678	
   679		 Resulting in these two pools::
   680	
   681		    default drivers pool:    adapter 0-15, domain 1
   682		    alternate drivers pool:  adapter 16-255, domains 0, 2-255
   683	
 > 684	   Note ***:
   685	   Changing a mask such that one or more APQNs will be taken from a vfio_ap
   686	   mediated device (see below) will fail with an error (EBUSY). A message
   687	   is logged to the kernel ring buffer which can be viewed with the 'dmesg'
   688	   command. The output identifies each APQN flagged as 'in use' and identifies
   689	   the vfio_ap mediated device to which it is assigned; for example:
   690	
   691	   Userspace may not re-assign queue 05.0054 already assigned to 62177883-f1bb-47f0-914d-32a22e3a8804
   692	   Userspace may not re-assign queue 04.0054 already assigned to cef03c3c-903d-4ecc-9a83-40694cb8aee4
   693	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
