Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0CD263F38D
	for <lists+kvm@lfdr.de>; Thu,  1 Dec 2022 16:17:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231602AbiLAPRT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Dec 2022 10:17:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231626AbiLAPRK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Dec 2022 10:17:10 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC19ECD989
        for <kvm@vger.kernel.org>; Thu,  1 Dec 2022 07:17:05 -0800 (PST)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B1F1Z6B016591
        for <kvm@vger.kernel.org>; Thu, 1 Dec 2022 15:17:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references : cc :
 subject : from : to : message-id : date; s=pp1;
 bh=R7oLHidk/oKSoH+/luxQ0przVU8MDTkuaU9ghZQ+S1s=;
 b=i4WmqQIFZFizAVp1z5PwmtaMkKwc18WOkXSAoN01/qDn2y1g86uZYZiG9eRJbVAgF54a
 edGUlugMUajx8jvshrY6anKS0RjTW7yUWJmvoMXhpzVgwoJEFrGIUBLGigI3q1Kxtq8d
 6bBXJ39x1klnRlHo5+5xdqgOgzbZU58a5D1i0gd4UnusgnvQ4Re9XbFUwGpudsthJuwE
 MW/9n6ozNXSTX29ncl0h90y6QAYmXtH35SOszN7KlSwi5Zrt4KS22spy3/4piCyw+sGv
 NscMmC7qSE1MY25UrVjVZgxOF3adQnhD/j8xH9CJWY+5Tt9OER/lJYlbARTl8fkutvoc vQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m6xj38hnv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 01 Dec 2022 15:17:05 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2B1F1bfr016684
        for <kvm@vger.kernel.org>; Thu, 1 Dec 2022 15:17:05 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m6xj38hms-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 01 Dec 2022 15:17:05 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2B1F5kFD017717;
        Thu, 1 Dec 2022 15:17:02 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04ams.nl.ibm.com with ESMTP id 3m3ae9fjaj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 01 Dec 2022 15:17:02 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2B1FGxXi5898832
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 1 Dec 2022 15:16:59 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CAEDC11C04C;
        Thu,  1 Dec 2022 15:16:59 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AEB1D11C04A;
        Thu,  1 Dec 2022 15:16:59 +0000 (GMT)
Received: from t14-nrb (unknown [9.171.4.226])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  1 Dec 2022 15:16:59 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20221201142758.4ac860d2@p-imbrenda>
References: <20221201084642.3747014-1-nrb@linux.ibm.com> <20221201084642.3747014-3-nrb@linux.ibm.com> <20221201142758.4ac860d2@p-imbrenda>
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, thuth@redhat.com,
        pbonzini@redhat.com
Subject: Re: [kvm-unit-tests PATCH v1 2/3] lib: s390x: skey: add seed value for storage keys
From:   Nico Boehr <nrb@linux.ibm.com>
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Message-ID: <166990781892.186408.3471589675936358214@t14-nrb.local>
User-Agent: alot/0.8.1
Date:   Thu, 01 Dec 2022 16:16:59 +0100
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: dj0Hshi7Q7NaI7kuU6M-4iOBlJwNtMd5
X-Proofpoint-GUID: B1q6M07VGHCUh9wO3UYgs5s549GcaFWK
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-01_04,2022-12-01_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 priorityscore=1501
 lowpriorityscore=0 clxscore=1015 mlxlogscore=560 spamscore=0
 impostorscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2212010109
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Claudio Imbrenda (2022-12-01 14:27:58)
> On Thu,  1 Dec 2022 09:46:41 +0100
> Nico Boehr <nrb@linux.ibm.com> wrote:
>=20
> > Upcoming changes will change storage keys in a loop. To make sure each
> > iteration of the loops sets different keys, add variants of the storage
> > key library functions which allow to specify a seed.
> >=20
> > Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
>=20
> I wonder if you can simply merge this patch with the previous one

Yes, I thought about that too, but I was not sure whether people will like =
this
approach, so I kept it as a seperate patch so I can undo it easily and it s=
tands
out a bit :)

I will merge with the previous commit if nobody complains.
