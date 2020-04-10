Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 220B81A451B
	for <lists+kvm@lfdr.de>; Fri, 10 Apr 2020 12:20:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725993AbgDJKUO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Apr 2020 06:20:14 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:51428 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725930AbgDJKUN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Apr 2020 06:20:13 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03AAJ9uQ119046;
        Fri, 10 Apr 2020 10:20:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=0G0SXSp0q/0L37C/DIXgGFdVawxsFUeBphgmgshcH20=;
 b=dRu2yvzr9ImMxm/HezfSd47lhuWROUTjEHynGyR9DBy7nO7bmMkoLmhuAJWwJON6FeTU
 hqE1oAJdHElx7hx7WYUGlG396cFo1Anke7DS6SKEWEpx5o1bDW6JLIJstAGKX/jM/AtZ
 KCyNOBtNt9falHzZOYrq78goxfzlGBrB7m9ZKJ+hk5fSZO1l6A2ZIsNxFzKWdwtLnh3j
 fCr2WRife1z/QU5/BTdn0qi9sqR2o0EtBdxbpIO2mVsyTA4vYcYUGk+tRk5qwLahwGEz
 N0kasfuYXdPzfIx6X9lisMIYlkdJoQwm6NAJylIMphHdujLrqzTeaelXFUcfMzAfu4SL qg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 309gw4hr7u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Apr 2020 10:20:09 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03AAHWhC105800;
        Fri, 10 Apr 2020 10:20:09 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 3091m714hy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Apr 2020 10:20:09 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 03AAK7NV008352;
        Fri, 10 Apr 2020 10:20:07 GMT
Received: from [192.168.14.112] (/79.180.216.197)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 10 Apr 2020 03:20:07 -0700
Subject: Re: Contribution to KVM.
To:     Nadav Amit <nadav.amit@gmail.com>,
        Javier Romero <xavinux@gmail.com>
Cc:     kvm <kvm@vger.kernel.org>, kvmarm@lists.cs.columbia.edu,
        like.xu@intel.com
References: <CAEX+82KTJecx_aSHAPN9ZkS_YDiDfyEM9b6ji4wabmSZ6O516Q@mail.gmail.com>
 <c86002a6-d613-c0be-a672-cca8e9c83e1c@intel.com>
 <2E118FCA-7AB1-480F-8F49-3EFD77CC2992@gmail.com>
From:   Liran Alon <liran.alon@oracle.com>
Message-ID: <9d46406f-c483-746b-058f-cceda22f1029@oracle.com>
Date:   Fri, 10 Apr 2020 13:20:03 +0300
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.13; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <2E118FCA-7AB1-480F-8F49-3EFD77CC2992@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9586 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0
 mlxlogscore=999 phishscore=0 spamscore=0 adultscore=0 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004100085
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9586 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 bulkscore=0
 phishscore=0 lowpriorityscore=0 impostorscore=0 clxscore=1011
 suspectscore=0 malwarescore=0 spamscore=0 mlxlogscore=999 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004100085
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 10/04/2020 6:52, Nadav Amit wrote:
> 2. Try to run the tests with more than 4GB of memory. The last time I tried
>     (actually by running the test on bare metal), the INIT test that Liran
>     wrote failed.
>
Wasn't this test failure fixed with kvm-unit-test commit fc47ccc19612 
("x86: vmx: Verify pending LAPIC INIT event consume when exit on VMX_INIT")?
If not, can you provide the details of this new failure? As I thought 
this commit address the previous issue you have reported when running 
this test
on bare-metal.

Thanks,
-Liran

