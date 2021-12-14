Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5CBF473EE2
	for <lists+kvm@lfdr.de>; Tue, 14 Dec 2021 10:01:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232041AbhLNJBK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Dec 2021 04:01:10 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:59702 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229782AbhLNJBJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 14 Dec 2021 04:01:09 -0500
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BE7URPw008390;
        Tue, 14 Dec 2021 09:01:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=jnW8pZk4Mp5UdhHrxyfZZjiQZLu2ioJJ+1pRGZ2PiOM=;
 b=qLPGYGk6SXUJjCya9cZiyy4flraVutMhQ6B7gukafLK5Q/eZWS4o9FMbGcz5V81/Y0vs
 Ni2dqjwunt7lbGgHWLbSLiUo7WOXZfGYhDvb9Fykll3ckXYXCKodQ8W1EZxcsWScQF22
 l464ZCblEFnNp8T7HYhumKkbk0MDyfcKJi0NuhzreBQDU2Cw8rQtfsbW+eveysNrbpKr
 YPD8VBG4NJ1iUNR5QpK24eIZ4hAYdaHvpvBLftT95Mo4lU+uHXnKr12KhDPGpIJTqdKs
 P2ryDr/6/72FKxJgVvuoxgWJIDUN2WukicBv6VBHVORhnDiJD8Eq/NEc1YCqhlDQ7/c6 GQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cx9ra5e2u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Dec 2021 09:01:08 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1BE7P8u8014427;
        Tue, 14 Dec 2021 09:01:08 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cx9ra5e1y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Dec 2021 09:01:08 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1BE8wBtB006281;
        Tue, 14 Dec 2021 09:01:06 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma06ams.nl.ibm.com with ESMTP id 3cvk8hvhcg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Dec 2021 09:01:06 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1BE912Mm42402108
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Dec 2021 09:01:02 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B5CC94203F;
        Tue, 14 Dec 2021 09:01:02 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 528D642041;
        Tue, 14 Dec 2021 09:01:02 +0000 (GMT)
Received: from [9.152.224.145] (unknown [9.152.224.145])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 14 Dec 2021 09:01:02 +0000 (GMT)
Message-ID: <01e383ae-9885-e384-f553-c3fbeb040192@linux.ibm.com>
Date:   Tue, 14 Dec 2021 10:01:02 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.4.0
Subject: Re: [PATCH v5 0/1] s390x: KVM: CPU Topology
Content-Language: en-US
To:     Pierre Morel <pmorel@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, cohuck@redhat.com,
        david@redhat.com, thuth@redhat.com, imbrenda@linux.ibm.com,
        hca@linux.ibm.com, gor@linux.ibm.com
References: <20211122131443.66632-1-pmorel@linux.ibm.com>
From:   Alexandra Winter <wintera@linux.ibm.com>
In-Reply-To: <20211122131443.66632-1-pmorel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: wOon2DKproMoLx5yYgbaF5rCkCAIKw2W
X-Proofpoint-ORIG-GUID: qIl1KYON2mGgsb8-WKBGzuqATTRmjL-X
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-14_03,2021-12-13_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 malwarescore=0 clxscore=1011 priorityscore=1501 spamscore=0 bulkscore=0
 mlxlogscore=910 lowpriorityscore=0 mlxscore=0 adultscore=0 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112140052
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 22.11.21 14:14, Pierre Morel wrote:
> Hi all,
> 
> This new series add the implementation of interpretation for
> the PTF instruction.
> 
> The series provides:
> 1- interception of the STSI instruction forwarding the CPU topology
> 2- interpretation of the PTF instruction
> 3- a KVM capability for the userland hypervisor to ask KVM to 
>    setup PTF interpretation.
> 
> 
> 0- Foreword
> 
[...]
> We will ignore the following changes inside a STSI(15.1.2):
> - polarization: only horizontal polarization is currently used in Linux.
> - CPU Type: only IFL Type are supported in Linux
I thought Linux can also run on General Purpose CPUs ??
