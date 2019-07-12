Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 86F3E66363
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2019 03:38:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729005AbfGLBiN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Jul 2019 21:38:13 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:42546 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726587AbfGLBiM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Jul 2019 21:38:12 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6C1YXGg120969;
        Fri, 12 Jul 2019 01:37:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2018-07-02;
 bh=UUQibFn516zSpiU9EIh8vT+iqeDCfU6g8uHMqSkxd4g=;
 b=P1bSvRrtVVekXjj+esEqo7c8osF1B3cyDE+dc3cTIwylBKgm+XTFNv2KeopA41FzNMJd
 OjiRyd3O3MkqrRZrs1p0rmQELM85yoh63eJI0HoLAhI8wuYlaX2i8EibLD+hPGGvP2m2
 d0c+M+t7lyrOhOcWuLBRYYDUqEjpNE2XXvmvkth0AlI9pw2qs+pqvSEcSghqCjk1AKId
 Qoh9zOWAy+9FUaCznnX9bZRDPlxTkPF8ODPQdXmUhh7B4jML0Ac/TeXy5hE0+7etfktu
 +38nuZWiUNGCSeII8SqI+1uDg3vVpp+HdsBkEdX0J8Ck0QrnQJVyUxoSz4RhF7DY+yKv Xw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2tjk2u32n0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Jul 2019 01:37:32 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6C1XUHL060147;
        Fri, 12 Jul 2019 01:37:32 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2tnc8tvhn6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Jul 2019 01:37:32 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x6C1bUhc003924;
        Fri, 12 Jul 2019 01:37:31 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 11 Jul 2019 18:37:30 -0700
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        jejb@linux.ibm.com, linux-scsi@vger.kernel.org, stefanha@redhat.com
Subject: Re: [PATCH 0/2] scsi: add support for request batching
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20190530112811.3066-1-pbonzini@redhat.com>
        <746ad64a-4047-1597-a0d4-f14f3529cc19@redhat.com>
        <yq1lfxnk8ar.fsf@oracle.com>
        <48c7d581-6ec8-260a-b4ba-217aef516305@redhat.com>
        <80dd68bf-a544-25ec-568f-cee1cf0c8cfd@suse.de>
        <6c2cf159-9ba2-da39-6e1c-95dea7e111ba@redhat.com>
Date:   Thu, 11 Jul 2019 21:37:25 -0400
In-Reply-To: <6c2cf159-9ba2-da39-6e1c-95dea7e111ba@redhat.com> (Paolo
        Bonzini's message of "Fri, 5 Jul 2019 13:58:39 +0200")
Message-ID: <yq11ryw6nje.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9315 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=854
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1907120018
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9315 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=910 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907120018
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Paolo,

> Stefan answered, and the series now has three reviews!  It may be late
> for 5.3 but I hope this can go in soon.

I queued these up for 5.4. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
