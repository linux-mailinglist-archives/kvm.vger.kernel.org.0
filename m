Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 967C7393268
	for <lists+kvm@lfdr.de>; Thu, 27 May 2021 17:26:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235894AbhE0P1f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 May 2021 11:27:35 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:58176 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235889AbhE0P1e (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 27 May 2021 11:27:34 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14RF3Yn0088364;
        Thu, 27 May 2021 11:26:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 content-transfer-encoding : mime-version; s=pp1;
 bh=1bSsUxYbjtDwrnd3Fej9ZlU+wrzJlR7qZNIivFG2yzM=;
 b=rDRxHdxsY4vXXsKkvN8nTiWlyXZbgfhEG6vE+sXd1QR9OUcMwE89gSmx6uoKCxyxwJUS
 HHgvDbXcWBeYHrnZzHA0fGlb9G0u9YCXDrB6O+Qvx+mGquU2Wcg2DI2fM/A8KWbMmTbc
 M/TcbwlJXbR1oB/Em/zHrpTXKGIFNAhFGEJw7N6uAwW4FoptM0x6tBIbuVc0JhVg3rIn
 rLBW5JhNy0jF4BZnNk0Qg4ZVR4fa3jMe/nqhdTt+q9wCxKKzj2FAePYGmZvsjIINxhAo
 Jd9u9RzTDWoIWmXoBxyrHCSW7/5Qx8g/YrwF4GVO8knHZ41HcKendoE9S9efNf9WHfIM wA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38tcc7c5hj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 May 2021 11:26:01 -0400
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 14RF57pC098080;
        Thu, 27 May 2021 11:26:00 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38tcc7c5gt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 May 2021 11:26:00 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 14RFAOtB030839;
        Thu, 27 May 2021 15:25:59 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma04ams.nl.ibm.com with ESMTP id 38s1r499f9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 May 2021 15:25:58 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 14RFPQbA29032898
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 May 2021 15:25:26 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 039AF52051;
        Thu, 27 May 2021 15:25:56 +0000 (GMT)
Received: from localhost (unknown [9.171.81.104])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTPS id AC49E52054;
        Thu, 27 May 2021 15:25:55 +0000 (GMT)
Date:   Thu, 27 May 2021 17:25:50 +0200
From:   Vasily Gorbik <gor@linux.ibm.com>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Heiko Carstens <hca@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: b4 usage (was: [PULL 0/3] vfio-ccw: some fixes)
Message-ID: <your-ad-here.call-01622129150-ext-7521@work.hours>
References: <20210520113450.267893-1-cohuck@redhat.com>
 <your-ad-here.call-01622068380-ext-9894@work.hours>
 <20210527083313.0f5b9553.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210527083313.0f5b9553.cohuck@redhat.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 8lyCo7_ZdE2_9CI9aIi3j0EHNMDYzjyX
X-Proofpoint-GUID: zlWXHNFfpDxV6aQnb_uFSAYcpxrmUEdw
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-27_07:2021-05-27,2021-05-27 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 suspectscore=0 spamscore=0 malwarescore=0 phishscore=0 clxscore=1015
 impostorscore=0 mlxlogscore=881 mlxscore=0 bulkscore=0 priorityscore=1501
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105270099
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> > BTW, linux-s390@vger.kernel.org is now archived on lore and we started
> 
> Oh, nice.
> 
> > using b4 (https://git.kernel.org/pub/scm/utils/b4/b4.git) to pick up
> > changes. Besides all other features, it can convert Message-Id: to Link:
> 
> I've been using b4 to pick patches (Linux and especially QEMU) for
> quite some time now, but never felt the need to convert Message-Id: to
> Link:. If you prefer the Link: format, I can certainly start using that
> for kernel patches.

It's up to you, whatever you prefer. Just wanted to point out that this is
possible now. I personally just follow what seems to be a more common practice.

$ git log --grep=Link:.*lore --oneline linux/master | wc -l
53522
$ git log --grep=Message-Id: --oneline linux/master | wc -l
1666


> > 
> > Hm, and b4 also now complains:
> > ✗ BADSIG: DKIM/ibm.com
> > have to look into that...

Ok, figured out that this is only failing with the company vpn. Internal
dns servers handle ibm.com domain, but fail to serve public key via
"pp1._domainkey.ibm.com" request, which is required to verify DKIM.
All works fine with external dns.
