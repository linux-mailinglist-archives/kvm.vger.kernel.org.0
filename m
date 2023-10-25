Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4ED847D6A8A
	for <lists+kvm@lfdr.de>; Wed, 25 Oct 2023 13:56:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234937AbjJYL4j (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Oct 2023 07:56:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234911AbjJYL4h (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Oct 2023 07:56:37 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD9DF13D;
        Wed, 25 Oct 2023 04:56:35 -0700 (PDT)
Received: from pps.filterd (m0353723.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39PBhAP2006482;
        Wed, 25 Oct 2023 11:56:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references : to :
 from : cc : subject : message-id : date; s=pp1;
 bh=3Pz7EaxM1duhEnWr0DW+Qoms/goOaNfxeLk/CZqQ6qA=;
 b=e+w/w5p3O6dU3iH87h7HTz5Oignmx94GEV19sVvJOdttdCkMYwKC2dfGaHvaxdljmQ8v
 aZpEXITm/Aqmq6o4gIRHHjgm45Lc+Iyk42v4GhUmUboYfVlH6smPh15TcxFrXdhqLut3
 OA4Q5Hk12/85YLvCKhrHBwnbg1Q/k9arvTza8OUS74mLtX2KVVVIU/O7Ll2mL/lZugoB
 tJGuCO67LdtI/Z33I3419k5G/J46DfHJSkuVtOWQkfWWKad3AFJUVmGDnqHJ4Fy2q88U
 NryFLxlkGzW3zvmWZVQo7pqz37nKpvuMLaNK56VMDL8egkpYq7cHd+xEwRnefbwesXzu 6g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ty2968f7j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 25 Oct 2023 11:56:22 +0000
Received: from m0353723.ppops.net (m0353723.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 39PBtNnX017728;
        Wed, 25 Oct 2023 11:56:21 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ty2968f72-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 25 Oct 2023 11:56:21 +0000
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
        by ppma12.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 39P9rOe3023807;
        Wed, 25 Oct 2023 11:56:20 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
        by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 3tvryt6kd0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 25 Oct 2023 11:56:20 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
        by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 39PBuHEA43778712
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Oct 2023 11:56:17 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9E1FE2004D;
        Wed, 25 Oct 2023 11:56:17 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 07BF920043;
        Wed, 25 Oct 2023 11:56:17 +0000 (GMT)
Received: from t14-nrb (unknown [9.171.74.186])
        by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 25 Oct 2023 11:56:16 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20231020144900.2213398-2-nsg@linux.ibm.com>
References: <20231020144900.2213398-1-nsg@linux.ibm.com> <20231020144900.2213398-2-nsg@linux.ibm.com>
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Nina Schoetterl-Glausch <nsg@linux.ibm.com>
From:   Nico Boehr <nrb@linux.ibm.com>
Cc:     Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Nikos Nikoleris <nikos.nikoleris@arm.com>,
        linux-s390@vger.kernel.org, Shaoqin Huang <shahuang@redhat.com>,
        Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        Andrew Jones <andrew.jones@linux.dev>,
        Ricardo Koller <ricarkol@google.com>,
        Colton Lewis <coltonlewis@google.com>,
        Thomas Huth <thuth@redhat.com>
Subject: Re: [kvm-unit-tests PATCH 01/10] s390x: topology: Introduce enums for polarization & cpu type
Message-ID: <169823497567.67523.4534307667737652588@t14-nrb>
User-Agent: alot/0.8.1
Date:   Wed, 25 Oct 2023 13:56:15 +0200
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: NUpmRjxm3igEo5xkaG-1x6r6kahkR22x
X-Proofpoint-GUID: SlRtGJ6qVxbI3h9eEC2NqhB3TKB-KSD6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-25_01,2023-10-25_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 lowpriorityscore=0 impostorscore=0 bulkscore=0 adultscore=0 phishscore=0
 mlxscore=0 spamscore=0 priorityscore=1501 mlxlogscore=664 malwarescore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2310170001 definitions=main-2310250103
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Nina Schoetterl-Glausch (2023-10-20 16:48:51)
> Thereby get rid of magic values.
>=20
> Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>

Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
