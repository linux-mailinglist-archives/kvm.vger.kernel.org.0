Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3F6D322D3E
	for <lists+kvm@lfdr.de>; Tue, 23 Feb 2021 16:14:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233162AbhBWPNr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Feb 2021 10:13:47 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:41130 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233085AbhBWPM6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 23 Feb 2021 10:12:58 -0500
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 11NF3Teu133435;
        Tue, 23 Feb 2021 10:12:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=89Ya7uugwpYcKJWKJXTH/IOyPSXnV/BKdu2kPgyyv/U=;
 b=pYWxhap6a41PS0errIvI3KM60/COiheFHx9EWWiqvQyXPGJRYwSlGYJLYBRSoODs26U+
 Yog00eBHn+o41ztGebo0NLdeViMHgvnQ/QTAK1CUTOXha6p1k/9IPcF+OuwIbsW912oM
 Sj1Ezz83f0WQsRmYg4beZjzgH3p66KxzYJGYjL5I4QNhfn+nd+Gc5XjyU0nRmYyjAxRB
 ye4AAUfed3+c1f4uUH1mJ14t3LEBPMK1pMA7U9M2PJmGQ2ZrVKBx6FuxAMW3/tfCxROa
 wbRJvGvj9gwb7LtBR9Drf0KCh93LglWXV+9eWpkR/luXYmZzzze6jAhjRqsA3OTh/bSF kg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36vkfktd1m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Feb 2021 10:12:08 -0500
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 11NF3ZqI134183;
        Tue, 23 Feb 2021 10:12:08 -0500
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36vkfktcyc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Feb 2021 10:12:08 -0500
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 11NF8BSw008504;
        Tue, 23 Feb 2021 15:12:05 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma04ams.nl.ibm.com with ESMTP id 36tt28aqd5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Feb 2021 15:12:05 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 11NFBobM25100784
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Feb 2021 15:11:50 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id ABC7311C052;
        Tue, 23 Feb 2021 15:12:02 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5AD5411C064;
        Tue, 23 Feb 2021 15:12:02 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.171.83.55])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 23 Feb 2021 15:12:02 +0000 (GMT)
Subject: Re: [PATCH v4 1/1] KVM: s390: diag9c (directed yield) forwarding
To:     Pierre Morel <pmorel@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        cohuck@redhat.com, david@redhat.com, thuth@redhat.com
References: <1613997661-22525-1-git-send-email-pmorel@linux.ibm.com>
 <1613997661-22525-2-git-send-email-pmorel@linux.ibm.com>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Message-ID: <ddbd3bc5-91f0-6588-6563-d5a890e210f2@de.ibm.com>
Date:   Tue, 23 Feb 2021 16:12:02 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <1613997661-22525-2-git-send-email-pmorel@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-02-23_08:2021-02-23,2021-02-23 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 mlxscore=0
 priorityscore=1501 mlxlogscore=999 bulkscore=0 suspectscore=0 phishscore=0
 clxscore=1015 malwarescore=0 adultscore=0 spamscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102230129
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 22.02.21 13:41, Pierre Morel wrote:
> When we intercept a DIAG_9C from the guest we verify that the
> target real CPU associated with the virtual CPU designated by
> the guest is running and if not we forward the DIAG_9C to the
> target real CPU.
> 
> To avoid a diag9c storm we allow a maximal rate of diag9c forwarding.
> 
> The rate is calculated as a count per second defined as a new
> parameter of the s390 kvm module: diag9c_forwarding_hz .
> 
> The default value of 0 is to not forward diag9c.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>

I will carry that via the s390kvm tree, thanks.
