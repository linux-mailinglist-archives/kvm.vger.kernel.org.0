Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D270E2D3E14
	for <lists+kvm@lfdr.de>; Wed,  9 Dec 2020 10:05:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728536AbgLIJCh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Dec 2020 04:02:37 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:18430 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725942AbgLIJCb (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 9 Dec 2020 04:02:31 -0500
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B98X6en091104;
        Wed, 9 Dec 2020 04:01:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=awsZamTLPaU+5tkz5kiSEfp1JQoyFZR14s0OZ+51DUs=;
 b=RIxw/UooIYfmtBcw2J7pLfoAlk0/eaRjbI9Ha1cgo2uIS7y/hXog8T9BzCwm2EZO7cMQ
 6gktpTEYo15OzNlMXufTG3ftsKPfME6HeT2/wWk9IS5QK8vqOwaLT97wRZyM5UwAblVS
 4W2QyqK9BGtZZ2Gdjjvah16X2tRi6iYvlwSiOpe0AePq/Qp0S0ehxhrt1vOn9GV3Vf2B
 5Fx2+2k8hALl5AWO1f1l6mpwOrxx/ydkp5ilM24iy12JbgUVd3fGHxMShdkiG5W0cnh+
 EEu3iPkNTL02F6S98Ty9rQYnT1xWB5/Y/6/NYNfe+s+Fg8WZ/27BsSK637JH1kSy+7a7 YQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35aqjyx78r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 09 Dec 2020 04:01:50 -0500
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0B98nblM150700;
        Wed, 9 Dec 2020 04:01:50 -0500
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35aqjyx77n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 09 Dec 2020 04:01:50 -0500
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0B98r7xM001215;
        Wed, 9 Dec 2020 09:01:48 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma06fra.de.ibm.com with ESMTP id 3581fhj8xm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 09 Dec 2020 09:01:48 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0B991jv661800750
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 9 Dec 2020 09:01:45 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C4A5C4C044;
        Wed,  9 Dec 2020 09:01:45 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6CCA34C059;
        Wed,  9 Dec 2020 09:01:45 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.171.15.225])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  9 Dec 2020 09:01:45 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH 0/2] s390x: Move from LGPL 2 to GPL 2
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     thuth@redhat.com, david@redhat.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org
References: <20201208150902.32383-1-frankja@linux.ibm.com>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Message-ID: <c91bd49f-4d4d-42d3-7551-195d0d77060a@de.ibm.com>
Date:   Wed, 9 Dec 2020 10:01:45 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201208150902.32383-1-frankja@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-09_07:2020-12-08,2020-12-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 clxscore=1015
 spamscore=0 lowpriorityscore=0 malwarescore=0 bulkscore=0 impostorscore=0
 priorityscore=1501 adultscore=0 suspectscore=0 mlxlogscore=956
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012090060
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 08.12.20 16:09, Janosch Frank wrote:
> KVM and the KVM unit tests should be able to share code to improve
> development speed and the LGPL is currently preventing us from doing
> exactly that. Additionally we have a multitude of different licenses
> in s390x files: GPL 2 only, GPL 2 or greater, LGPL 2 and LGPL 2.1 or
> later.
> 
> This patch set tries to move the licenses to GPL 2 where
> possible. Also we introduce the SPDX identifiers so the file headers
> are more readable.
> 

Makes perfect sense.
Acked-by: Christian Borntraeger <borntraeger@de.ibm.com
