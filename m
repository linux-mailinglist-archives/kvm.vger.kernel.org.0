Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 501247D6B40
	for <lists+kvm@lfdr.de>; Wed, 25 Oct 2023 14:22:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343522AbjJYMWJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Oct 2023 08:22:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343667AbjJYMWI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Oct 2023 08:22:08 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A2CACE;
        Wed, 25 Oct 2023 05:22:06 -0700 (PDT)
Received: from pps.filterd (m0353726.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39PBvVbl023044;
        Wed, 25 Oct 2023 12:22:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references : to :
 from : cc : subject : message-id : date; s=pp1;
 bh=Y0vL/lG4ZxV5RCYBIOG32Eo1C6yp49JdmCHr2BVs0HQ=;
 b=JoxiWBadPc3dn+2gk+CIQIEc/WedaUVO4s7CtAjPqfv1/YBLv21hkHr1fT2qty+HTZRH
 w268rqsaNO1zbksaBFD0AN3YsnGgdhBlzX7Oas7aH96ZxBEnRjWjGejfXBy5s1eaiRAF
 ipn/uS2G967WsJ+oMRFqtlZsXlYUbOZyLmO0c1jkHh7tlJ58zxAoRiv4MhNL9WVMrBik
 YBxdGOhbBBiUy57pEe7l1PmJFr2ZeEiEppYgesCAG/mHp9ILH7lbRBAzPthjsZSq+m3J
 bB80wpOiN+T1ZxlCv9ZiaNidF3HPF9iKCGi+UKk8b3gZyIlCpQPb6/Jyc55utQkj7Fpr 7A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ty2kj8xnw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 25 Oct 2023 12:22:01 +0000
Received: from m0353726.ppops.net (m0353726.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 39PBwBlA025293;
        Wed, 25 Oct 2023 12:22:00 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ty2kj8xna-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 25 Oct 2023 12:22:00 +0000
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
        by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 39PABvU7010231;
        Wed, 25 Oct 2023 12:21:59 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
        by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3tvsbypnqt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 25 Oct 2023 12:21:59 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
        by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 39PCLuUu37028360
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Oct 2023 12:21:56 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3366120049;
        Wed, 25 Oct 2023 12:21:56 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 11FF720040;
        Wed, 25 Oct 2023 12:21:56 +0000 (GMT)
Received: from t14-nrb (unknown [9.171.74.186])
        by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 25 Oct 2023 12:21:55 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20231020144900.2213398-1-nsg@linux.ibm.com>
References: <20231020144900.2213398-1-nsg@linux.ibm.com>
To:     Andrew Jones <andrew.jones@linux.dev>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Colton Lewis <coltonlewis@google.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Nikos Nikoleris <nikos.nikoleris@arm.com>,
        Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
        Sean Christopherson <seanjc@google.com>,
        Shaoqin Huang <shahuang@redhat.com>,
        Thomas Huth <thuth@redhat.com>
From:   Nico Boehr <nrb@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, David Hildenbrand <david@redhat.com>,
        kvm@vger.kernel.org, Ricardo Koller <ricarkol@google.com>
Subject: Re: [kvm-unit-tests PATCH 00/10] s390x: topology: Fixes and extension
Message-ID: <169823651572.67523.10556581938548735484@t14-nrb>
User-Agent: alot/0.8.1
Date:   Wed, 25 Oct 2023 14:21:55 +0200
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 6eQmygIFNWPOHdBodVtcdIpxBeTNtj3O
X-Proofpoint-ORIG-GUID: ep7GZkfElDfruBx-P22rkODZQCMIKFmY
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-25_01,2023-10-25_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 spamscore=0
 suspectscore=0 priorityscore=1501 mlxlogscore=999 phishscore=0 mlxscore=0
 impostorscore=0 adultscore=0 malwarescore=0 lowpriorityscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2310170001
 definitions=main-2310250107
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Nina Schoetterl-Glausch (2023-10-20 16:48:50)
> v1 -> v2:
>  * patch 1, introducing enums (Janosch)
>  * add comment explaining 8 alignment of stsi block length
>  * unsigned cpu_in_masks, iteration (Nico)
>  * fix copy paste error when checking ordering (thanks Nina)
>  * don't escape newline when \\ at end of line in multiline string
>  * change commit messages (thanks Janosch, thanks Nico)
>  * pick up tags (thanks Janosch, thanks Nico)
>=20
> Fix a number of issues as well as rewrite and extend the topology list
> checking.
> Add a test case with a complex topology configuration.
> In order to keep the unittests.cfg file readable, implement multiline
> strings for extra_params.

Thanks, I've pushed this to our CI for coverage.
