Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A01D2B158C
	for <lists+kvm@lfdr.de>; Fri, 13 Nov 2020 06:31:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726163AbgKMFbZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Nov 2020 00:31:25 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:61976 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726071AbgKMFbZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 13 Nov 2020 00:31:25 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AD5VCGe098813;
        Fri, 13 Nov 2020 00:31:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=M83UjsrNDgeM2HZvDszm+vdvsRyoGiWYM9osyiwugQA=;
 b=sk160YL77C/CndwEDpzwIpanWLqHmjuG8cyp26+NU0IYyBY95RHYPhmuUCyZmxw5rJGW
 l28IM5RKy48Biv9axGNMeuZtYdx/YUYd2lpafZeOoLFUv4MKr4LNt/fQB995O+fbE31r
 3EcwsvkbNGdZUsNMXzlK3AIC4pTzRfCPwidpGYjWA5mleGLr3YCbiNwI+kUjROel5e8j
 4Ukqtcix8k1XEDEFosPcCbBGG3RpToehbbQ2lOv6o0bHRN9I62caIP7Av8BNuh/GDbMX
 8oKmBOD5rRZcfLz5EAfD8TS9ijOricTPG6VkQdiU9+h+mbkpWD9QrCL/7CnQ04CkTMEh HQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 34skwg85s2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 Nov 2020 00:31:14 -0500
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0AD5VDsq098936;
        Fri, 13 Nov 2020 00:31:13 -0500
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0b-001b2d01.pphosted.com with ESMTP id 34skwg85q1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 Nov 2020 00:31:13 -0500
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0AD5RPst015068;
        Fri, 13 Nov 2020 05:31:02 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma05fra.de.ibm.com with ESMTP id 34nk78b8vq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 Nov 2020 05:31:02 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0AD5Uxn136110832
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Nov 2020 05:31:00 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E1FF14C04E;
        Fri, 13 Nov 2020 05:30:59 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8F38B4C044;
        Fri, 13 Nov 2020 05:30:59 +0000 (GMT)
Received: from ozlabs.au.ibm.com (unknown [9.192.253.14])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 13 Nov 2020 05:30:59 +0000 (GMT)
Received: from [9.81.218.112] (unknown [9.81.218.112])
        (using TLSv1.2 with cipher AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by ozlabs.au.ibm.com (Postfix) with ESMTPSA id 4953AA0114;
        Fri, 13 Nov 2020 16:30:57 +1100 (AEDT)
Subject: Re: [PATCH kernel] vfio_pci_nvlink2: Do not attempt NPU2 setup on old
 P8's NPU
To:     Alexey Kardashevskiy <aik@ozlabs.ru>, linuxppc-dev@lists.ozlabs.org
Cc:     Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org,
        David Gibson <david@gibson.dropbear.id.au>
References: <20201113050632.74124-1-aik@ozlabs.ru>
From:   Andrew Donnellan <ajd@linux.ibm.com>
Message-ID: <0b8ceab2-e304-809f-be3c-512b28b25852@linux.ibm.com>
Date:   Fri, 13 Nov 2020 16:30:56 +1100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201113050632.74124-1-aik@ozlabs.ru>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-13_03:2020-11-12,2020-11-13 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 adultscore=0 spamscore=0 clxscore=1011 mlxlogscore=793 mlxscore=0
 malwarescore=0 suspectscore=8 phishscore=0 priorityscore=1501
 impostorscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2011130029
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13/11/20 4:06 pm, Alexey Kardashevskiy wrote:
> We execute certain NPU2 setup code (such as mapping an LPID to a device
> in NPU2) unconditionally if an Nvlink bridge is detected. However this
> cannot succeed on P8+ machines as the init helpers return an error other
> than ENODEV which means the device is there is and setup failed so
> vfio_pci_enable() fails and pass through is not possible.
> 
> This changes the two NPU2 related init helpers to return -ENODEV if
> there is no "memory-region" device tree property as this is
> the distinction between NPU and NPU2.
> 
> Fixes: 7f92891778df ("vfio_pci: Add NVIDIA GV100GL [Tesla V100 SXM2] subdriver")
> Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>

Should this be Cc: stable?


Andrew

-- 
Andrew Donnellan              OzLabs, ADL Canberra
ajd@linux.ibm.com             IBM Australia Limited
