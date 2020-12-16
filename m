Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AA882DC779
	for <lists+kvm@lfdr.de>; Wed, 16 Dec 2020 21:01:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728556AbgLPUBh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Dec 2020 15:01:37 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:42044 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727027AbgLPUBg (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 16 Dec 2020 15:01:36 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0BGJWKsW177543;
        Wed, 16 Dec 2020 15:00:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=ukgGyv0rQrNMw1i5qVhyrpzV7aI2cPAKbS26lUD1rD4=;
 b=jyUKVUCaZdk6IIN3JP5H68NPSX0S1319O3XcyKl4oIvXIJFi4+EpNw0oWD8880SQJTvA
 24elereFaOXGRDIP1O9rKzob5Gb+g0Qxe5+LGQqWWrrdT3Mc9MWhD4cDARALwAJ8uLAj
 oADv2Piab/FQ0NCH2wVkiIzMywkGBxT6nHXLvbaHPaIaxs42wvVeypffNHJOMCxe0fzo
 Crw80v2T7U4GLLZiFQ395e8hetnnvMtWUHEq06qw3aZXdEJUhszB3Cp0GHTovFjr/+Nt
 Qmo0tFLKuwKJYBLiDoxeSwtj5NEvhlFKJ32HprAhwsm+6IGpanFd8HO/IEEr7btFPRwU tw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 35fp0bngud-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 16 Dec 2020 15:00:52 -0500
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0BGJewTk019937;
        Wed, 16 Dec 2020 15:00:51 -0500
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0b-001b2d01.pphosted.com with ESMTP id 35fp0bngu3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 16 Dec 2020 15:00:51 -0500
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0BGJvP2H015580;
        Wed, 16 Dec 2020 20:00:50 GMT
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
        by ppma04dal.us.ibm.com with ESMTP id 35cng9jsba-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 16 Dec 2020 20:00:50 +0000
Received: from b03ledav005.gho.boulder.ibm.com (b03ledav005.gho.boulder.ibm.com [9.17.130.236])
        by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0BGK0lFD25625038
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 16 Dec 2020 20:00:47 GMT
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 33EE0BE053;
        Wed, 16 Dec 2020 20:00:47 +0000 (GMT)
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C07B1BE04F;
        Wed, 16 Dec 2020 20:00:45 +0000 (GMT)
Received: from cpe-66-24-58-13.stny.res.rr.com (unknown [9.85.193.150])
        by b03ledav005.gho.boulder.ibm.com (Postfix) with ESMTP;
        Wed, 16 Dec 2020 20:00:45 +0000 (GMT)
Subject: Re: [PATCH v12 09/17] s390/vfio-ap: sysfs attribute to display the
 guest's matrix
To:     Halil Pasic <pasic@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, freude@linux.ibm.com, borntraeger@de.ibm.com,
        cohuck@redhat.com, mjrosato@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        hca@linux.ibm.com, gor@linux.ibm.com
References: <20201124214016.3013-1-akrowiak@linux.ibm.com>
 <20201124214016.3013-10-akrowiak@linux.ibm.com>
 <20201129014904.4fafdbba.pasic@linux.ibm.com>
From:   Tony Krowiak <akrowiak@linux.ibm.com>
Message-ID: <831cbbac-06bb-dade-c291-2e1954003da4@linux.ibm.com>
Date:   Wed, 16 Dec 2020 15:00:45 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20201129014904.4fafdbba.pasic@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-16_08:2020-12-15,2020-12-16 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 phishscore=0 suspectscore=0 bulkscore=0 adultscore=0 clxscore=1015
 malwarescore=0 mlxscore=0 spamscore=0 mlxlogscore=999 priorityscore=1501
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012160118
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Thanks for the review.

On 11/28/20 7:49 PM, Halil Pasic wrote:
> On Tue, 24 Nov 2020 16:40:08 -0500
> Tony Krowiak <akrowiak@linux.ibm.com> wrote:
>
>> The matrix of adapters and domains configured in a guest's APCB may
>> differ from the matrix of adapters and domains assigned to the matrix mdev,
>> so this patch introduces a sysfs attribute to display the matrix of
>> adapters and domains that are or will be assigned to the APCB of a guest
>> that is or will be using the matrix mdev. For a matrix mdev denoted by
>> $uuid, the guest matrix can be displayed as follows:
>>
>>     cat /sys/devices/vfio_ap/matrix/$uuid/guest_matrix
>>
>> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
> Code looks good, but it may be a little early, since the treatment of
> guset_matrix is changed by the following patches.

