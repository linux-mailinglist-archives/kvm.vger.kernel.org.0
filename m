Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D9041B9C4
	for <lists+kvm@lfdr.de>; Mon, 13 May 2019 17:18:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731211AbfEMPSm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 May 2019 11:18:42 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:49060 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728783AbfEMPSm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 May 2019 11:18:42 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4DF9oxF029760;
        Mon, 13 May 2019 15:17:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2018-07-02; bh=7dwMUJzRttDvJYwhnTS2pvQini1VnZvpMgmhpc63TNI=;
 b=s+iOIvIzPv8p+qdn5Lp87nwsGe8piEJpWQ3OZW90Gqa7nfhqwc5jki1ocfhV8tfSYzyW
 ERQWmQkk0Drp6M39yqnyF2g5hWg8ckFsDEpZVMimRtrkJrFmN42X06Mw0JuVxtOyFXFQ
 ZM3y1OBAffh3lZwD1UORvYQyqw2FVoBLsR/ICZWoOVz30V9X8ZVIhod3gTSiGDDdcVAE
 BIDNG0vWG0mrq+wPCV1tkOBE/AwOEA2iQNd9Wj0ltYBVmaSz96NorsvT640eIhHYb7gR
 dKR2h7IcfhTPGL9nD1ygG8RWeV0LY/JCpb8KY+qu5uHfxDcfChNM5u9rLq4YgfLdHDAE yw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2sdq1q7m9k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 May 2019 15:17:53 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4DFHYQU140196;
        Mon, 13 May 2019 15:17:53 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2sdnqj1a07-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 May 2019 15:17:53 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x4DFHo3J020928;
        Mon, 13 May 2019 15:17:50 GMT
Received: from [10.30.3.22] (/213.57.127.2)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 13 May 2019 08:17:49 -0700
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 11.1 \(3445.4.7\))
Subject: Re: [RFC KVM 01/27] kernel: Export memory-management symbols required
 for KVM address space isolation
From:   Liran Alon <liran.alon@oracle.com>
In-Reply-To: <20190513151550.GZ2589@hirez.programming.kicks-ass.net>
Date:   Mon, 13 May 2019 18:17:42 +0300
Cc:     Alexandre Chartre <alexandre.chartre@oracle.com>,
        pbonzini@redhat.com, rkrcmar@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        dave.hansen@linux.intel.com, luto@kernel.org, kvm@vger.kernel.org,
        x86@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        konrad.wilk@oracle.com, jan.setjeeilers@oracle.com,
        jwadams@google.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <6CAE8F45-E2C0-453F-B2C8-12D9BBE6B8D7@oracle.com>
References: <1557758315-12667-1-git-send-email-alexandre.chartre@oracle.com>
 <1557758315-12667-2-git-send-email-alexandre.chartre@oracle.com>
 <20190513151550.GZ2589@hirez.programming.kicks-ass.net>
To:     Peter Zijlstra <peterz@infradead.org>
X-Mailer: Apple Mail (2.3445.4.7)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9255 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1905130105
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9255 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905130105
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On 13 May 2019, at 18:15, Peter Zijlstra <peterz@infradead.org> wrote:
>=20
> On Mon, May 13, 2019 at 04:38:09PM +0200, Alexandre Chartre wrote:
>> From: Liran Alon <liran.alon@oracle.com>
>>=20
>> Export symbols needed to create, manage, populate and switch
>> a mm from a kernel module (kvm in this case).
>>=20
>> This is a hacky way for now to start.
>> This should be changed to some suitable memory-management API.
>=20
> This should not be exported at all, ever, end of story.
>=20
> Modules do not get to play with address spaces like that.

I agree=E2=80=A6 No doubt about that. This should never be merged like =
this.
It=E2=80=99s just to have an initial PoC of the concept so we can:
1) Messure performance impact of concept.
2) Get feedback on appropriate design and APIs from community.

-Liran

