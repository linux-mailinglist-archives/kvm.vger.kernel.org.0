Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9ADF200B9
	for <lists+kvm@lfdr.de>; Thu, 16 May 2019 09:55:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726707AbfEPHy5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 May 2019 03:54:57 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:34216 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726454AbfEPHy5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 May 2019 03:54:57 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4G7sUlc186465;
        Thu, 16 May 2019 07:54:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2018-07-02; bh=wlI4FuevQ2mhRamMuoO2zlRoWsnWTKc4nNrjHwGyT60=;
 b=5gQuHnUnkp2m3kS9rfSBd3os2IJV71BbS7WODagQKTlCsBuQxH6EYMnLBrHyDcpw1iyo
 uR01tB/m9/P47nCYDeEO0K3cIRJfRDsEs+VdRd53QLuYW3dHSZVQH8t/jKN5Wd7v5Hnd
 PfuesEeYPyXvUOA3jfz7+5GH6TDwU4qOPxzZSUJnzO65/UIpsUKJpwRCBw/ohrXzrRCy
 FF+KNl31MGykrkmBi6GVk10pDAsfKV6+toEBomis4vMybBxgX22XjnWbZVEWW2O7TCGS
 LtznRa3KTiTwcMN0tWCBO5IkpRrFV3IAIBFaUI1t9rHq5DHG8htKF0LRq1PUQevkQHwN PQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2sdq1qsfcw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 May 2019 07:54:48 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4G7rOSd024323;
        Thu, 16 May 2019 07:54:47 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2sggethpg5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 May 2019 07:54:47 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x4G7slYB019462;
        Thu, 16 May 2019 07:54:47 GMT
Received: from [10.0.5.57] (/213.57.127.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 16 May 2019 00:54:47 -0700
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 11.1 \(3445.4.7\))
Subject: Re: Question about MDS mitigation
From:   Liran Alon <liran.alon@oracle.com>
In-Reply-To: <f513e534-2c7b-f32b-7346-1a64edf0db73@huawei.com>
Date:   Thu, 16 May 2019 10:54:43 +0300
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Huangzhichao <huangzhichao@huawei.com>,
        guijianfeng <guijianfeng@huawei.com>,
        gaowanlong <gaowanlong@huawei.com>,
        "Chentao (Boby)" <boby.chen@huawei.com>,
        "Liujinsong (Paul)" <liu.jinsong@huawei.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <39F1D5C9-BD42-4E9F-BE56-2473B4713B82@oracle.com>
References: <f513e534-2c7b-f32b-7346-1a64edf0db73@huawei.com>
To:     "wencongyang (A)" <wencongyang2@huawei.com>
X-Mailer: Apple Mail (2.3445.4.7)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9258 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=880
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1905160054
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9258 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=910 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905160054
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Indeed those CPU resources are shared between sibling hyperthreads on =
same CPU core.
There is currently no mechanism merged upstream to completely mitigate =
SMT-enabled scenarios.
Note that this is also true for L1TF.

There are several proposal to address this but they are still in early =
research mode.
For example, see this KVM address space isolation patch series developed =
by myself and Alexandre:
https://lkml.org/lkml/2019/5/13/515
(Which should be integrated with a mechanism which kick sibling =
hyperthreads when switching from KVM isolated address space to full =
kernel address space)
This partially mimics Microsoft work regarding HyperClear which you can =
read more about it here:
=
https://techcommunity.microsoft.com/t5/Virtualization/Hyper-V-HyperClear-M=
itigation-for-L1-Terminal-Fault/ba-p/382429

-Liran

> On 16 May 2019, at 5:42, wencongyang (A) <wencongyang2@huawei.com> =
wrote:
>=20
> Hi all
>=20
> Fill buffers, load ports are shared between threads on the same =
physical core.
> We need to run more than one vm on the same physical core.
> Is there any complete mitigation for environments utilizing SMT?
>=20

