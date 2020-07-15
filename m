Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0CE5221710
	for <lists+kvm@lfdr.de>; Wed, 15 Jul 2020 23:33:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727114AbgGOVde (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jul 2020 17:33:34 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:35428 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726670AbgGOVdd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jul 2020 17:33:33 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06FLWMWK170055;
        Wed, 15 Jul 2020 21:33:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=dJpwRH43bvmzPuOX+KuRh/HQe2BzY4Kd7PHUDAV8t5Y=;
 b=OX5mX6k7mkyG4e3uohryd4zVdoSKIHA+3CVptrCEJ78AoQDAip7r32IRCs4MNQFA1dDK
 c2vyhX/sgHTPGyfWPJbOqEy3hqSKn+v6NpNlQFJUe3Apzf5uplMPX6YiDpp+6Tbikg+P
 1QFGFklU95SvvUU2+oQPiTzWltOBQddnQEhVvAhv7awmQpS5Pt9x72jnhhLfBLEqgDTT
 fOe5EUCPIYHS0Ec+0SvHFmOipXY5pMdE4gclv29iqtIJ38dIhmGYirS5Zrldf8Iln6Av
 ZFsh23fy9QfIhNLT9wgrxfTMHDRp27/Xh8qVzLDaSRJm0VTzPqVgkk83XBj9fKnXBiPy Gw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 3274urdycd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 15 Jul 2020 21:33:27 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06FL8g8i028231;
        Wed, 15 Jul 2020 21:31:26 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 327qc1s610-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Jul 2020 21:31:26 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 06FLVPiV015926;
        Wed, 15 Jul 2020 21:31:25 GMT
Received: from localhost.localdomain (/10.159.239.115)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 15 Jul 2020 14:31:25 -0700
Subject: Re: [kvm-unit-tests PATCH 0/2] nVMX: Two PCIDE related fixes
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Karl Heubaum <karl.heubaum@oracle.com>,
        Oliver Upton <oupton@google.com>,
        Jim Mattson <jmattson@google.com>
References: <20200714002355.538-1-sean.j.christopherson@intel.com>
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Message-ID: <e96bc66b-856e-7454-28fb-7662343c4940@oracle.com>
Date:   Wed, 15 Jul 2020 14:31:24 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20200714002355.538-1-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9683 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0
 mlxlogscore=999 bulkscore=0 malwarescore=0 mlxscore=0 phishscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007150160
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9683 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 impostorscore=0
 suspectscore=0 phishscore=0 spamscore=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 priorityscore=1501 adultscore=0 bulkscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007150161
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 7/13/20 5:23 PM, Sean Christopherson wrote:
> PCIDE fixes for two completely unrelated tests that managed to combine
> powers and create a super confusing error where the MTF test loads CR3
> with 0 and sends things into the weeds.
>
> Sean Christopherson (2):
>    nVMX: Restore active host RIP/CR4 after test_host_addr_size()
>    nVMX: Use the standard non-canonical value in test_mtf3
>
>   x86/vmx_tests.c | 7 ++++++-
>   1 file changed, 6 insertions(+), 1 deletion(-)
>
Reviewed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
