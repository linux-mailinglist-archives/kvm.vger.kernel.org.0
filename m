Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 972742498AC
	for <lists+kvm@lfdr.de>; Wed, 19 Aug 2020 10:53:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726840AbgHSIwt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Aug 2020 04:52:49 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:27892 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727030AbgHSIvs (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 19 Aug 2020 04:51:48 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07J8XFV6070490;
        Wed, 19 Aug 2020 04:51:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=S+nsWlwf+U8EP6ck/CPDu7nHuTHsUi9kQOKDLthEZ9Q=;
 b=niSdGqNeGZ9z/4yhvg5wOGNU03UEjPnZ5q9uYkK5QyIwjvUVG+54rYq+f0/dwzXdPOtZ
 tNkJO2QMpIQ8czSZPvO+jn33v0pasbPNusJdL+gwsEFJsUDRaGrpQ9TsrU0lDvxvT6j9
 EY6gzahMWidXzHi1evQzdMDuP2PhadIFJVk0QUwEp8526YLCMZP5b7v0sWgaiH80hey+
 e7C4P+flw6+DduFgUEgTTltCwcfbFBlmQZIBSXVkrIAL8DslUWkIPnP96aFLRxsWjAEK
 8BNU8o0RigFLyaY12uwNz9hkGtDnVLFztexUkoU31bMRITpqU4T+iLo4P1AzkSofgkmh /w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3304r4ag78-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Aug 2020 04:51:38 -0400
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 07J8YQdb073315;
        Wed, 19 Aug 2020 04:51:38 -0400
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3304r4ag6h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Aug 2020 04:51:38 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 07J8oHjh026071;
        Wed, 19 Aug 2020 08:51:36 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma02fra.de.ibm.com with ESMTP id 3304bbs0pq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Aug 2020 08:51:36 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 07J8pXnY32113038
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Aug 2020 08:51:33 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7BA6511C04A;
        Wed, 19 Aug 2020 08:51:33 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DE1B311C04C;
        Wed, 19 Aug 2020 08:51:32 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.33.131])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 19 Aug 2020 08:51:32 +0000 (GMT)
Subject: Re: [PATCH v8 2/2] s390: virtio: PV needs VIRTIO I/O device
 protection
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     linux-kernel@vger.kernel.org, pasic@linux.ibm.com,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, mst@redhat.com,
        jasowang@redhat.com, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org,
        virtualization@lists.linux-foundation.org, thomas.lendacky@amd.com,
        david@gibson.dropbear.id.au, linuxram@us.ibm.com,
        hca@linux.ibm.com, gor@linux.ibm.com
References: <1597762711-3550-1-git-send-email-pmorel@linux.ibm.com>
 <1597762711-3550-3-git-send-email-pmorel@linux.ibm.com>
 <20200818192233.6c80798e.cohuck@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <2a0e6ac5-1238-fd7b-f39f-6fad767b1493@linux.ibm.com>
Date:   Wed, 19 Aug 2020 10:51:32 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200818192233.6c80798e.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-19_04:2020-08-19,2020-08-19 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 phishscore=0
 lowpriorityscore=0 clxscore=1015 impostorscore=0 bulkscore=0
 priorityscore=1501 suspectscore=0 mlxlogscore=804 mlxscore=0 adultscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008190073
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2020-08-18 19:22, Cornelia Huck wrote:

>> + */
>> +int arch_has_restricted_memory_access(struct virtio_device *dev)
>> +{
>> +	if (!is_prot_virt_guest())
>> +		return 0;
> 
> If you just did a
> 
> return is_prot_virt_guest();
> 
> and did the virtio feature stuff in the virtio core, this function
> would be short and sweet :)


yes, the smaller the better, thanks

Pierre

-- 
Pierre Morel
IBM Lab Boeblingen
