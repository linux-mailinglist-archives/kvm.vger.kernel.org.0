Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56E1818BE98
	for <lists+kvm@lfdr.de>; Thu, 19 Mar 2020 18:45:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728655AbgCSRpJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Mar 2020 13:45:09 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:11558 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727769AbgCSRpH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 19 Mar 2020 13:45:07 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02JHcNgn121429;
        Thu, 19 Mar 2020 13:44:59 -0400
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2yvcw9rr3k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 Mar 2020 13:44:59 -0400
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 02JHWdYG017794;
        Thu, 19 Mar 2020 17:44:58 GMT
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
        by ppma03wdc.us.ibm.com with ESMTP id 2yrpw6t6wj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 Mar 2020 17:44:58 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 02JHivuv29491622
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 Mar 2020 17:44:57 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 95B6778060;
        Thu, 19 Mar 2020 17:44:57 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7E3527805C;
        Thu, 19 Mar 2020 17:44:56 +0000 (GMT)
Received: from localhost (unknown [9.85.143.6])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTPS;
        Thu, 19 Mar 2020 17:44:55 +0000 (GMT)
From:   Fabiano Rosas <farosas@linux.ibm.com>
To:     Greg Kurz <groug@kaod.org>, Paul Mackerras <paulus@ozlabs.org>
Cc:     kvm@vger.kernel.org, kvm-ppc@vger.kernel.org,
        David Gibson <david@gibson.dropbear.id.au>,
        Ram Pai <linuxram@us.ibm.com>
Subject: Re: [PATCH] KVM: PPC: Book3S HV: Add a capability for enabling secure guests
In-Reply-To: <20200319173000.20e10c7b@bahia.lan>
References: <20200319043301.GA13052@blackberry> <20200319173000.20e10c7b@bahia.lan>
Date:   Thu, 19 Mar 2020 14:44:53 -0300
Message-ID: <87eetoutm2.fsf@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-19_06:2020-03-19,2020-03-19 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 suspectscore=1
 impostorscore=0 adultscore=0 mlxlogscore=881 spamscore=0
 priorityscore=1501 clxscore=1011 malwarescore=0 mlxscore=0 bulkscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003190073
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Greg Kurz <groug@kaod.org> writes:

>
> Reviewed-by: Greg Kurz <groug@kaod.org>
>
> Is someone working on wiring this up in QEMU ?
>

I just did so I could test it. =)

If no one else is doing it I could send my patch as an RFC and we
iterate from that.
