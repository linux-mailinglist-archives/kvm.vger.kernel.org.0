Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE205194AC8
	for <lists+kvm@lfdr.de>; Thu, 26 Mar 2020 22:40:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727541AbgCZVk0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Mar 2020 17:40:26 -0400
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:14561 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727026AbgCZVk0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Mar 2020 17:40:26 -0400
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5e7d20ed0000>; Thu, 26 Mar 2020 14:38:53 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Thu, 26 Mar 2020 14:40:25 -0700
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Thu, 26 Mar 2020 14:40:25 -0700
Received: from [10.40.103.35] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 26 Mar
 2020 21:40:06 +0000
Subject: Re: [PATCH v15 Kernel 1/7] vfio: KABI for migration interface for
 device state
To:     Christoph Hellwig <hch@infradead.org>
CC:     <alex.williamson@redhat.com>, <cjia@nvidia.com>,
        <kevin.tian@intel.com>, <ziye.yang@intel.com>,
        <changpeng.liu@intel.com>, <yi.l.liu@intel.com>,
        <mlevitsk@redhat.com>, <eskultet@redhat.com>, <cohuck@redhat.com>,
        <dgilbert@redhat.com>, <jonathan.davies@nutanix.com>,
        <eauger@redhat.com>, <aik@ozlabs.ru>, <pasic@linux.ibm.com>,
        <felipe@nutanix.com>, <Zhengxiao.zx@alibaba-inc.com>,
        <shuangtai.tst@alibaba-inc.com>, <Ken.Xue@amd.com>,
        <zhi.a.wang@intel.com>, <yan.y.zhao@intel.com>,
        <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>
References: <1584649004-8285-1-git-send-email-kwankhede@nvidia.com>
 <1584649004-8285-2-git-send-email-kwankhede@nvidia.com>
 <20200326093310.GA12078@infradead.org>
X-Nvconfidentiality: public
From:   Kirti Wankhede <kwankhede@nvidia.com>
Message-ID: <d7918318-ff3a-04dd-9c80-41098a777f7f@nvidia.com>
Date:   Fri, 27 Mar 2020 03:09:58 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200326093310.GA12078@infradead.org>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1585258733; bh=V2c3guzclP/omsTo+UqpgNGxiLDtiViGM07WNO9Zcys=;
        h=X-PGP-Universal:Subject:To:CC:References:X-Nvconfidentiality:From:
         Message-ID:Date:User-Agent:MIME-Version:In-Reply-To:
         X-Originating-IP:X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=ldni9GAu9CbAvCrWziJ8CzSJk+U86sz4bwGpQvmyqOHvJQ9MzMzSxOE3II/5GObw/
         igHgkh1yJKEcd6kGWWWtk1lMiW12cPWZmwDW2jRRQIfKxhsxJC91T2yZ8tizT12Pao
         JIpkNisz89X1cQUVGlkYD0FegHNW7ofz+PqfCKmZU5o1wIMEmxDYeUVqiBDb8ENL5y
         phQFm5EjSrlfr0B4VpsRhJswhp+EbSUhCbmGsPINByOHlE0+CTvkln8xzBkMs+7gE/
         L+1IWx9rNwud1axYuxWeOdc5/t26RxR5hOGcN1Pkf0vzdEhe5wDEZX1MQmrEn/JlsN
         bR63XL6Cbjfww==
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 3/26/2020 3:03 PM, Christoph Hellwig wrote:
> s/KABI/UAPI/ in the subject and anywhere else in the series.
> 

Ok.

> Please avoid __packed__ structures and just properly pad them, they
> have a major performance impact on some platforms and will cause
> compiler warnings when taking addresses of members.
> 

Yes, removing it.

Thanks,
Kirti
