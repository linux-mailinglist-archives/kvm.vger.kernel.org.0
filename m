Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E1B44ED640
	for <lists+kvm@lfdr.de>; Thu, 31 Mar 2022 10:51:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233387AbiCaIx0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 31 Mar 2022 04:53:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233382AbiCaIxZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 31 Mar 2022 04:53:25 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25C5562BF5
        for <kvm@vger.kernel.org>; Thu, 31 Mar 2022 01:51:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648716697; x=1680252697;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=AJhSb2adOnH4x8zWZD1Xoit68/Zd7wJssWmMSp6l/Ls=;
  b=gz9r10+XfHCh++kK+3JHkBm/vf6Ko7d3vJeWxt/tCZminZBR17+TXo7O
   S3gG++9si7Gy61Fr07ntnGkdg2d7hVmq+/dNTRuruOW+GM4WvnCQW4YIp
   VF4tJ5AAMaWyVs+CuUGn1whU4X+cDX7maHbps1BF+pOepv7aIzdLzlRHW
   edzZlB310YiOneaxjMe5xj+qdCz2wY1EI3IMNCGPl2WJJrPwKkhP+zm1v
   D5xUFWNsmeR7aGGqlbHgmF1ZHUIzy2r8QEZZT+Udc0YYNsGwIQeoSL5mt
   4YZC7YlLApGWGWiWWtGGkxga82fPxq1CfhL6p1RNHCbPrbimDU6YGB4pX
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10302"; a="240357054"
X-IronPort-AV: E=Sophos;i="5.90,224,1643702400"; 
   d="scan'208";a="240357054"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2022 01:51:35 -0700
X-IronPort-AV: E=Sophos;i="5.90,224,1643702400"; 
   d="scan'208";a="547232848"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.249.193.1]) ([10.249.193.1])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2022 01:51:29 -0700
Message-ID: <1d5b0192-75ef-49ad-dc47-cfc0c3c63455@intel.com>
Date:   Thu, 31 Mar 2022 16:51:27 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.6.1
Subject: Re: [RFC PATCH v3 17/36] pflash_cfi01/tdx: Introduce ram_mode of
 pflash for TDVF
Content-Language: en-US
To:     =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>
Cc:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= 
        <philippe.mathieu.daude@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>,
        Richard Henderson <richard.henderson@linaro.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Laszlo Ersek <lersek@redhat.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        Connor Kuehl <ckuehl@redhat.com>, isaku.yamahata@intel.com,
        erdemaktas@google.com, kvm@vger.kernel.org, qemu-devel@nongnu.org,
        seanjc@google.com
References: <20220317135913.2166202-1-xiaoyao.li@intel.com>
 <20220317135913.2166202-18-xiaoyao.li@intel.com>
 <f418548e-c24c-1bc3-4e16-d7a775298a18@gmail.com>
 <7a8233e4-0cae-b05a-7931-695a7ee87fc9@intel.com>
 <YjmWhMVx80/BFY8z@redhat.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <YjmWhMVx80/BFY8z@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/22/2022 5:27 PM, Daniel P. Berrangé wrote:
...
> IMHO the AmdSev build for OVMF gets this right by entirely disabling
> the split OVMF_CODE.fd vs OVMF_VARS.fd, and just having a single
> OVMF.fd file that is exposed read-only to the guest.
> 
> This is further represented in $QEMU.git/docs/interop/firmware.json
> by marking the firmware as 'stateless', which apps like libvirt will
> use to figure out what QEMU command line to pick.

Hi Daniel,

I don't play with AMD SEV and I'm not sure if AMD SEV requires only 
single OVMF.fd. But IIUC, from edk2

commit 437eb3f7a8db ("OvmfPkg/QemuFlashFvbServicesRuntimeDxe: Bypass 
flash detection with SEV-ES")

, AMD SEV(-ES) does support NVRAM via proactive VMGEXIT MMIO 
QemuFlashWrite(). If so, AMD SEV seems to be able to support split OVMF, 
right?

> IOW, if you don't want OVMF_VARS.fd to be written to, then follow
> what AmdSev has done, and get rid of the split files.
> 
> 
> With regards,
> Daniel

