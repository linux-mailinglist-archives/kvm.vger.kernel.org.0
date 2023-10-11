Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E1377C55B0
	for <lists+kvm@lfdr.de>; Wed, 11 Oct 2023 15:42:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234985AbjJKNl7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Oct 2023 09:41:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234904AbjJKNl5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Oct 2023 09:41:57 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4EC6B6;
        Wed, 11 Oct 2023 06:41:54 -0700 (PDT)
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39BDe44M018412;
        Wed, 11 Oct 2023 13:41:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references :
 subject : to : cc : from : message-id : date; s=pp1;
 bh=1LRfXvRpB6rL08iXZ89rsQDegbgG+NqiUFR6NwWmpBo=;
 b=O6fquoKUs+sLmtsnMe3BoW07NMmHcbIvxUZ/SwkHEFrbQfY0DjpnPL8EwArF/vyxb1pQ
 RzN5wU6X1WFq4j7wKzcYMkrcEGqpogkDFSjZxC7iUpAOv6R5oE0+rFEOy0yWgssAXZmn
 /AY4exMz0+WjcwGkGOoqcjQtptbEOcWOqw+Mo7yv/eSMsnvk7uDPoT1rpH5iRTIuEkL0
 biPlpTtdSMoC+PFXJpOV86AJ5cgELJQfwFBlDTrkK0oYEkOf8Six+isN/5JR6nqSTQ9m
 ZNLl/E+qKVFny8XRrAkP1vDG4LieLiFSgrdGQum22C/5cvAW3BY1YN1doEAsfs2LxObx tQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3tnvstr5b9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 11 Oct 2023 13:41:48 +0000
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 39BDeIdI019625;
        Wed, 11 Oct 2023 13:41:47 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3tnvstr4ar-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 11 Oct 2023 13:41:46 +0000
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
        by ppma23.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 39BC00wc000647;
        Wed, 11 Oct 2023 13:36:34 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3tkk5kr250-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 11 Oct 2023 13:36:34 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 39BDaV2Q8389178
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 11 Oct 2023 13:36:31 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 14CBC2004B;
        Wed, 11 Oct 2023 13:36:31 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0248C20043;
        Wed, 11 Oct 2023 13:36:31 +0000 (GMT)
Received: from t14-nrb (unknown [9.152.224.84])
        by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 11 Oct 2023 13:36:30 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20231011085635.1996346-2-nsg@linux.ibm.com>
References: <20231011085635.1996346-1-nsg@linux.ibm.com> <20231011085635.1996346-2-nsg@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH 1/9] s390x: topology: Fix report message
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Nina Schoetterl-Glausch <nsg@linux.ibm.com>
Cc:     Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Thomas Huth <thuth@redhat.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, Andrew Jones <andrew.jones@linux.dev>,
        Colton Lewis <coltonlewis@google.com>,
        Nikos Nikoleris <nikos.nikoleris@arm.com>,
        Sean Christopherson <seanjc@google.com>
From:   Nico Boehr <nrb@linux.ibm.com>
Message-ID: <169703139080.15053.7484690709413943726@t14-nrb>
User-Agent: alot/0.8.1
Date:   Wed, 11 Oct 2023 15:36:30 +0200
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Yd1eDgG96rXG0ooQC9hh87nPJsNRXIKl
X-Proofpoint-GUID: XuC6jahXr1rjsx_IopGauKkAECt_Eiqi
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-11_09,2023-10-11_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 priorityscore=1501 clxscore=1011 mlxscore=0 malwarescore=0 mlxlogscore=812
 suspectscore=0 bulkscore=0 lowpriorityscore=0 adultscore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2309180000 definitions=main-2310110120
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Nina Schoetterl-Glausch (2023-10-11 10:56:24)
> A polarization value of 0 means horizontal polarization.
>=20
> Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>

Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
