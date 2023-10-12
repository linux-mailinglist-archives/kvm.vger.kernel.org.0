Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A1767C70FD
	for <lists+kvm@lfdr.de>; Thu, 12 Oct 2023 17:08:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347282AbjJLPIZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Oct 2023 11:08:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379183AbjJLPIR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Oct 2023 11:08:17 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66669C4;
        Thu, 12 Oct 2023 08:08:15 -0700 (PDT)
Received: from pps.filterd (m0353726.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39CF6AhJ025228;
        Thu, 12 Oct 2023 15:08:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references : from
 : subject : cc : to : message-id : date; s=pp1;
 bh=ut3/hJUGB/VwhDN/vHeKa+Wxe0KRvu3/0a7SgW+pGWI=;
 b=se6Azl5JO3B92TzQHXgH70Uicx+2hlM5ZIQ3xKHP9azkFab8SopyczM8V9MOarNBuaMD
 jsfUdpHtusAUZ1s6pnQq0hprhb0wHjkqLHBGSUhjyxVmzKyPk/E9O95wA9pF7b0WN3f2
 AMrBtR/owQhCro+TH5CJdxj2BVDOMX1GuhnlJOYG9J84uLTGgRgqycDL0pJifc3IP9c/
 kes3oVxBwmvlUQan38G/78t/u7O1lM0YWxLMJNXMEe+tf70YwUgeTDlUk86ryRNr6BIM
 SU3vkSzoYoKvXfuWLIXRGM6uiykTAMMYn5rYdY85fE/v6PxMaiQ+FJhOK7RZpIPEvmVm aw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3tpk0yrbbp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 Oct 2023 15:08:01 +0000
Received: from m0353726.ppops.net (m0353726.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 39CF6WIf028663;
        Thu, 12 Oct 2023 15:08:00 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3tpk0yrba4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 Oct 2023 15:08:00 +0000
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
        by ppma12.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 39CEWw8O024465;
        Thu, 12 Oct 2023 14:46:10 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 3tkhnt0f6h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 Oct 2023 14:46:10 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 39CEk7ot19268196
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Oct 2023 14:46:07 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B469C20043;
        Thu, 12 Oct 2023 14:46:07 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 90D1320040;
        Thu, 12 Oct 2023 14:46:07 +0000 (GMT)
Received: from t14-nrb (unknown [9.171.48.18])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 12 Oct 2023 14:46:07 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20231011085635.1996346-4-nsg@linux.ibm.com>
References: <20231011085635.1996346-1-nsg@linux.ibm.com> <20231011085635.1996346-4-nsg@linux.ibm.com>
From:   Nico Boehr <nrb@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH 3/9] s390x: topology: Fix parsing loop
Cc:     Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
        Andrew Jones <andrew.jones@linux.dev>,
        Colton Lewis <coltonlewis@google.com>,
        Nikos Nikoleris <nikos.nikoleris@arm.com>,
        Ricardo Koller <ricarkol@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Huth <thuth@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Nina Schoetterl-Glausch <nsg@linux.ibm.com>
Message-ID: <169712196713.20608.14802427939765958998@t14-nrb>
User-Agent: alot/0.8.1
Date:   Thu, 12 Oct 2023 16:46:07 +0200
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Z1zaT_lhYGyc9zgVfCTasJ2tWl150hNr
X-Proofpoint-ORIG-GUID: 1gRjvaY6sIdMgNOcaNZ_ntti8PNKNQaz
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-12_05,2023-10-12_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 lowpriorityscore=0
 mlxlogscore=691 priorityscore=1501 phishscore=0 adultscore=0
 malwarescore=0 impostorscore=0 clxscore=1015 suspectscore=0 bulkscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2309180000 definitions=main-2310120125
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Nina Schoetterl-Glausch (2023-10-11 10:56:26)
> Without a comparison the loop is infinite.
>=20
> Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>

Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
