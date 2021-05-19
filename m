Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4D1C38923E
	for <lists+kvm@lfdr.de>; Wed, 19 May 2021 17:08:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354324AbhESPKI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 May 2021 11:10:08 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:45358 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348804AbhESPKG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 May 2021 11:10:06 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14JF5rt9115755;
        Wed, 19 May 2021 15:08:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=O4M1xcTAuM/DDdc0c5CDLl/yAMutYPdkSv4nE2h3AeI=;
 b=oiJTPjfiELJ31h/2dywpDTju0Qrln1slSZD7cshRMtRC1k/KtXgpy+pe9GMtWVazE3OI
 T43P/YIzlig6H66ly2aKF7u3kVapM/k15DD0B3UxeQsIhQv1NV4PSFyb1WryaUD1CZBQ
 FFqwljp8bpOKSyJyNYB4Wyq6SDS4HwAvqlsz2komMzLQEXQsZLN1fCER+K8D+To2ry0B
 517gY7iFWGrcvZqNfJ/TIrh0AA140vIF1hgaDBZIlVAvxVIcAQtm5DiurBep9g+eiZUT
 UjhhSKTy+SXYwuNJTzyt18K3FAEz/7vz4bre9m2YARBqXaWviYUKa//gMujh8daNUqZY gQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 38j5qr9wfu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 May 2021 15:08:32 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14JF03JH086247;
        Wed, 19 May 2021 15:08:32 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3020.oracle.com with ESMTP id 38mecjfk91-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 May 2021 15:08:32 +0000
Received: from aserp3020.oracle.com (aserp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 14JF52Qc141441;
        Wed, 19 May 2021 15:08:31 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 38mecjfk6v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 May 2021 15:08:31 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 14JF8S9g005989;
        Wed, 19 May 2021 15:08:28 GMT
Received: from kadam (/41.212.42.34)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 19 May 2021 08:08:27 -0700
Date:   Wed, 19 May 2021 18:08:14 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Anup Patel <anup@brainfault.org>,
        Anup Patel <anup.patel@wdc.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Jonathan Corbet <corbet@lwn.net>,
        Alexander Graf <graf@amazon.com>,
        Atish Patra <atish.patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        KVM General <kvm@vger.kernel.org>,
        kvm-riscv@lists.infradead.org,
        linux-riscv <linux-riscv@lists.infradead.org>,
        linux-doc@vger.kernel.org,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        linux-staging@lists.linux.dev
Subject: Re: [PATCH v18 00/18] KVM RISC-V Support
Message-ID: <20210519150814.GY1955@kadam>
References: <20210519033553.1110536-1-anup.patel@wdc.com>
 <YKSa48cejI1Lax+/@kroah.com>
 <CAAhSdy18qySXbUdrEsUe-KtbtuEoYrys0TcmsV2UkEA2=7UQzw@mail.gmail.com>
 <YKSgcn5gxE/4u2bT@kroah.com>
 <YKTsyyVYsHVMQC+G@kroah.com>
 <d7d5ad76-aec3-3297-0fac-a9da9b0c3663@redhat.com>
 <YKUDWgZVj82/KiKw@kroah.com>
 <daa30135-8757-8d33-a92e-8db4207168ff@redhat.com>
 <YKUZbb6OK+UYAq+t@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YKUZbb6OK+UYAq+t@kroah.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-GUID: DSYkubxMfO3UDZdxS1ycNWkOZn5DmMy3
X-Proofpoint-ORIG-GUID: DSYkubxMfO3UDZdxS1ycNWkOZn5DmMy3
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9989 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 impostorscore=0
 mlxscore=0 lowpriorityscore=0 malwarescore=0 mlxlogscore=999
 suspectscore=0 adultscore=0 priorityscore=1501 spamscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105190095
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

It's sort of frustrating that none of this information was in the commit
message.

"This code is not ready to be merged into the arch/risc/ directory
because the RISC-V Foundation has not certified the hardware spec yet.
However, the following chips have implemented it ABC12345, ABC6789 and
they've already shipping to thousands of customers since blah blah blah
so we should support it."

I honestly thought it was an issue with the code or the userspace API.

regards,
dan carpenter

