Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B62A79770A
	for <lists+kvm@lfdr.de>; Thu,  7 Sep 2023 18:20:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239680AbjIGQUS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Sep 2023 12:20:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239790AbjIGQTy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Sep 2023 12:19:54 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5E26B186;
        Thu,  7 Sep 2023 08:46:38 -0700 (PDT)
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3878cUaV000863;
        Thu, 7 Sep 2023 08:50:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references :
 subject : from : cc : to : message-id : date; s=pp1;
 bh=dFCc0qTzdrwocEFsIvYEmIazAX+uga/LQ0XFfx6bZ88=;
 b=oAo/j4yONZbUSveEubI2aOck2s8VuNJaOrGzLLPkZfWcoqqyXJp+gsKBX7uMrQ3u+H5U
 j2v94I6epJWe8amRHfcQA9KfMKIPbZnL0x4PB8wULDZI6iMPzveB/gOLpEjDJfq5lZZN
 lT4NdO8X5BBNuKqYW2JGIRSEVtwjg8mLSgb5G785uioblkJJomxezK/T7dYD2OYH0IEH
 G4e+wB2EUXCxxAy2MTJqs2GCpRvtUEZeGg5/s+R2BJegxgnKm3+nhtm+Q/sy8LujVILK
 Wy7man1Ps2dVqZLATpMGHNDhC8CFWJRv4vcvfZVOeCku0SN11Yr9s2Vp9DtHhDvLNT7H Uw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3syay10g9y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Sep 2023 08:50:37 +0000
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3878cdcP001441;
        Thu, 7 Sep 2023 08:50:36 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3syay10g9q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Sep 2023 08:50:36 +0000
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
        by ppma21.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3878eq1x026756;
        Thu, 7 Sep 2023 08:50:35 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
        by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3svgcnt9d4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Sep 2023 08:50:35 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
        by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3878oWqA35651852
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 7 Sep 2023 08:50:32 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1F6A220040;
        Thu,  7 Sep 2023 08:50:32 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 001F52004E;
        Thu,  7 Sep 2023 08:50:31 +0000 (GMT)
Received: from t14-nrb (unknown [9.179.12.47])
        by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu,  7 Sep 2023 08:50:31 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <411a4c35-4f65-c166-0eb0-994b8e39f9c6@redhat.com>
References: <20230904130140.22006-1-nrb@linux.ibm.com> <a41f6fc29032d345b3c2f24e19f32282dd627e5c.camel@linux.ibm.com> <169390280362.97137.14761686200997364254@t14-nrb> <411a4c35-4f65-c166-0eb0-994b8e39f9c6@redhat.com>
Subject: Re: [PATCH v3 0/2] KVM: s390: add counters for vsie performance
From:   Nico Boehr <nrb@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
To:     David Hildenbrand <david@redhat.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        borntraeger@linux.ibm.com, frankja@linux.ibm.com,
        imbrenda@linux.ibm.com
Message-ID: <169407663163.12126.3803431831591387133@t14-nrb>
User-Agent: alot/0.8.1
Date:   Thu, 07 Sep 2023 10:50:31 +0200
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: BhrJnjoYTD1nFzWJQvZ5BqKEbpcnCZqd
X-Proofpoint-GUID: cIKtLQdGh3AmXR6UWn-yP6R12VeXYDi0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-09-06_12,2023-09-05_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=437
 lowpriorityscore=0 bulkscore=0 adultscore=0 phishscore=0 spamscore=0
 malwarescore=0 clxscore=1015 priorityscore=1501 suspectscore=0
 impostorscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2308100000 definitions=main-2309070074
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting David Hildenbrand (2023-09-06 09:37:28)
[...]
> Right, the compiler can do what it wants with that. The question is if=20
> we care about a slight imprecision, though.
>=20
> Probably not worth the trouble for something that never happens and is=20
> only used for debugging purposes.

Yep, probably true. Thanks!
