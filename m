Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 290A1379F9
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2019 18:46:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727158AbfFFQqC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jun 2019 12:46:02 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:33546 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726379AbfFFQqC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 6 Jun 2019 12:46:02 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x56GZwwT053510;
        Thu, 6 Jun 2019 12:45:34 -0400
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2sy6ga0e4g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 06 Jun 2019 12:45:33 -0400
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id x56COBIg027973;
        Thu, 6 Jun 2019 12:33:47 GMT
Received: from b03cxnp08027.gho.boulder.ibm.com (b03cxnp08027.gho.boulder.ibm.com [9.17.130.19])
        by ppma01dal.us.ibm.com with ESMTP id 2swybybt53-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 06 Jun 2019 12:33:47 +0000
Received: from b03ledav001.gho.boulder.ibm.com (b03ledav001.gho.boulder.ibm.com [9.17.130.232])
        by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x56GjVGf25297306
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 6 Jun 2019 16:45:31 GMT
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1D8BB6E052;
        Thu,  6 Jun 2019 16:45:31 +0000 (GMT)
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 481096E056;
        Thu,  6 Jun 2019 16:45:30 +0000 (GMT)
Received: from oc4221205838.ibm.com (unknown [9.85.197.175])
        by b03ledav001.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu,  6 Jun 2019 16:45:30 +0000 (GMT)
Subject: Re: [PATCH RFC 0/1] mdevctl: further config for vfio-ap
To:     Cornelia Huck <cohuck@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>
Cc:     kvm@vger.kernel.org, libvir-list@redhat.com,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>
References: <20190606144417.1824-1-cohuck@redhat.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
Openpgp: preference=signencrypt
Message-ID: <234ed452-45bd-e7ec-f1be-929e3b77d364@linux.ibm.com>
Date:   Thu, 6 Jun 2019 12:45:29 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190606144417.1824-1-cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-06_12:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906060112
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/6/19 10:44 AM, Cornelia Huck wrote:
> This patch adds a very rough implementation of additional config data
> for mdev devices. The idea is to make it possible to specify some
> type-specific key=value pairs in the config file for an mdev device.
> If a device is started automatically, the device is stopped and restarted
> after applying the config.
> 
> The code has still some problems, like not doing a lot of error handling
> and being ugly in general; but most importantly, I can't really test it,
> as I don't have the needed hardware. Feedback welcome; would be good to
> know if the direction is sensible in general.

Hi Connie,

This is very similar to what I was looking to do in zdev (config via
key=value pairs), so I like your general approach.

I pulled your code and took it for a spin on an LPAR with access to
crypto cards:

# mdevctl create-mdev `uuidgen` matrix vfio_ap-passthrough
# mdevctl set-additional-config <uuid> ap_adapters=0x4,0x5
# mdevctl set-additional-config <uuid> ap_domains=0x36
# mdevctl set-additional-config <uuid> ap_control_domains=0x37

Assuming all valid inputs, this successfully creates the appropriate
mdev and what looks to be a valid mdevctl.d entry.  A subsequent reboot
successfully brings the same vfio_ap-passthrough device up again.

Matt

> 
> Also available at
> 
> https://github.com/cohuck/mdevctl conf-data
> 
> Cornelia Huck (1):
>   allow to specify additional config data
> 
>  mdevctl.libexec | 25 ++++++++++++++++++++++
>  mdevctl.sbin    | 56 ++++++++++++++++++++++++++++++++++++++++++++++++-
>  2 files changed, 80 insertions(+), 1 deletion(-)
> 

