Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7494F2835D9
	for <lists+kvm@lfdr.de>; Mon,  5 Oct 2020 14:35:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725967AbgJEMfi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Oct 2020 08:35:38 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:42486 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725891AbgJEMfi (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 5 Oct 2020 08:35:38 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 095CX935100744
        for <kvm@vger.kernel.org>; Mon, 5 Oct 2020 08:35:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=6lhxMqsFMEG3PXSsHksuxVeb+stqZLmdkpObz+DjBbU=;
 b=HV56n5Pt0w2Cbtfo3wC3ylwZwVF2Fg6olA1XJBQIyXvYtiPi/t/Sciz4nyiYbw4IBs/H
 5aln2WYHD80Ct/wxRLHmHUKcB+z72yvzWr/idpjH9PZT/+JrhiLkuttScthIXgBM0LNP
 fwFI4xV8AwH0lOawC558GlK22eDefyq3/zuE4PTV27h81N8soOpKJvtJsEAFzidRkiJE
 MgFog1+TRzDz8sPsbW4q3ydcE1f+POYLkXFA3UVlfXu6Qrtf5ZgMZJfeVymgDKMyYJvB
 ryJvDMm9ofW6QwD4+DR2MWdRIAOczqH6NIpcZEZX+fO46jiWAworSjEWm/lgUYiJupjj pg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34013pc8y9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 05 Oct 2020 08:35:36 -0400
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 095CXFfr100965
        for <kvm@vger.kernel.org>; Mon, 5 Oct 2020 08:35:16 -0400
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34013pc8vj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 05 Oct 2020 08:35:15 -0400
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 095CWtBB027048;
        Mon, 5 Oct 2020 12:35:09 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma01fra.de.ibm.com with ESMTP id 33xgx7s3yg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 05 Oct 2020 12:35:09 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 095CZ6VO27394322
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 5 Oct 2020 12:35:06 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BB07F52057;
        Mon,  5 Oct 2020 12:35:06 +0000 (GMT)
Received: from ibm-vm (unknown [9.145.2.175])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 1B76352059;
        Mon,  5 Oct 2020 12:35:06 +0000 (GMT)
Date:   Mon, 5 Oct 2020 14:35:03 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Pierre Morel <pmorel@linux.ibm.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, frankja@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, cohuck@redhat.com,
        lvivier@redhat.com
Subject: Re: [kvm-unit-tests PATCH v2 0/7] Rewrite the allocators
Message-ID: <20201005143503.669922f5@ibm-vm>
In-Reply-To: <aec4a269-efba-83c0-cbbb-c78b132b1fa9@linux.ibm.com>
References: <20201002154420.292134-1-imbrenda@linux.ibm.com>
        <aec4a269-efba-83c0-cbbb-c78b132b1fa9@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.6 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-05_07:2020-10-02,2020-10-05 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 suspectscore=0
 priorityscore=1501 bulkscore=0 adultscore=0 phishscore=0
 lowpriorityscore=0 spamscore=0 mlxlogscore=434 malwarescore=0
 clxscore=1015 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2010050095
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 5 Oct 2020 13:54:42 +0200
Pierre Morel <pmorel@linux.ibm.com> wrote:

[...]

> While doing a page allocator, the topology is not the only 
> characteristic we may need to specify.
> Specific page characteristics like rights, access flags, cache
> behavior may be useful when testing I/O for some architectures.
> This obviously will need some connection to the MMU handling.
> 
> Wouldn't it be interesting to use a bitmap flag as argument to 
> page_alloc() to define separate regions, even if the connection with
> the MMU is done in a future series?

the physical allocator is only concerned with the physical pages. if
you need special MMU flags to be set, then you should enable the MMU
and fiddle with the flags and settings yourself.
