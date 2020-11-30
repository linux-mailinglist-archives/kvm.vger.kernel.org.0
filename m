Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A9402C8716
	for <lists+kvm@lfdr.de>; Mon, 30 Nov 2020 15:49:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726906AbgK3Osw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Nov 2020 09:48:52 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:15800 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726467AbgK3Osv (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 30 Nov 2020 09:48:51 -0500
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AUE4FkY030210;
        Mon, 30 Nov 2020 09:48:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=AEqqkPeobS7YA/6vemqN+eMZctQgdXreXgyjo0DutUQ=;
 b=mDdifL4gMNC/tmtQMLuOQ78l4Rl+gPGwqE1AHwrA0ZLQW1Q7OD7oFeitY/ma0xyt63oC
 5sxH4LaokuhlpuxkWX8oRnCXpmWyC8bAsc5XO7AgySYwFR2VTn0lXnlMBBEV+X28Val8
 x5o41NqU0+Gy7PboQM4DErPGO6X8Kue90cii+ooK9JXtBxV/OAQdBdT0ETumxJEvHQkW
 9Imlu90NYdskl9Z4K0qMHU684EpfvW4pPaysYV0C86vKiWBOwP8ataDtr2CuNZHCbQWN
 68ha52lt/AnbX0gkSePN1tvjfnEgRnwLJkS9wHjXdokclrlEs+NCh0ejZF6btOAhGY+W iA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3551673es1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 30 Nov 2020 09:48:10 -0500
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0AUE4VJc031199;
        Mon, 30 Nov 2020 09:48:10 -0500
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3551673er5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 30 Nov 2020 09:48:10 -0500
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0AUEi8VR019849;
        Mon, 30 Nov 2020 14:48:08 GMT
Received: from b01cxnp22033.gho.pok.ibm.com (b01cxnp22033.gho.pok.ibm.com [9.57.198.23])
        by ppma02wdc.us.ibm.com with ESMTP id 353e68r9rd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 30 Nov 2020 14:48:08 +0000
Received: from b01ledav006.gho.pok.ibm.com (b01ledav006.gho.pok.ibm.com [9.57.199.111])
        by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0AUEm7wn16056914
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 30 Nov 2020 14:48:07 GMT
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 25217AC05B;
        Mon, 30 Nov 2020 14:48:07 +0000 (GMT)
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4D80FAC05E;
        Mon, 30 Nov 2020 14:48:06 +0000 (GMT)
Received: from cpe-66-24-58-13.stny.res.rr.com (unknown [9.85.195.249])
        by b01ledav006.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon, 30 Nov 2020 14:48:06 +0000 (GMT)
Subject: Re: [PATCH v12 03/17] 390/vfio-ap: use new AP bus interface to search
 for queue devices
To:     Halil Pasic <pasic@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, freude@linux.ibm.com, borntraeger@de.ibm.com,
        cohuck@redhat.com, mjrosato@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        hca@linux.ibm.com, gor@linux.ibm.com
References: <20201124214016.3013-1-akrowiak@linux.ibm.com>
 <20201124214016.3013-4-akrowiak@linux.ibm.com>
 <20201126113412.62c0f42b.pasic@linux.ibm.com>
From:   Tony Krowiak <akrowiak@linux.ibm.com>
Message-ID: <7dc9d997-9f58-0d44-6754-01bd62b3eb63@linux.ibm.com>
Date:   Mon, 30 Nov 2020 09:48:05 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20201126113412.62c0f42b.pasic@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-30_03:2020-11-30,2020-11-30 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 adultscore=0
 impostorscore=0 suspectscore=3 malwarescore=0 clxscore=1015
 lowpriorityscore=0 bulkscore=0 mlxlogscore=999 spamscore=0 phishscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011300091
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 11/26/20 5:34 AM, Halil Pasic wrote:
> On Tue, 24 Nov 2020 16:40:02 -0500
> Tony Krowiak <akrowiak@linux.ibm.com> wrote:
>
> A nit: for all other patches the title prefix is  s390/vfio-ap, here you
> have 390/vfio-ap.

I'll fix that.


